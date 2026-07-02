#!/usr/bin/env python3
"""RHCSA simulator — browser exam paper ("Red Hat Test Exam"), faithful to the
real EX200 remote-exam interface. Python 3 standard library ONLY (offline-safe).

Served on 127.0.0.1 by `rhcsa-sim tui`. Read-only paper + a VM control panel;
actions (check / hint / solution / vm) shell out to the rhcsa-sim CLI so all the
tested logic (node2 forwarding, practice gating, reset) is reused, not duplicated.

Layout reproduces the real exam: left white sidebar (Red Hat shadowman, "Red Hat /
Test Exam", a pale-yellow/salmon "Time remaining" box, "Select Language"), and a
cream serif main area with "Configuration Information" + per-host task groups, each
task a "Configure your system NN" link with Revisit/Done radios.
"""
import argparse, html, json, os, pwd, re, subprocess, sys, time, urllib.parse, webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

ANSI = re.compile(r"\x1b\[[0-9;]*m")
ARGS = None


# ----------------------------------------------------------------- data helpers
def load_session():
    try:
        return json.load(open(ARGS.session, encoding="utf-8"))
    except Exception:
        return {}


def node_conf():
    d = {}
    p = os.path.join(ARGS.state, "node.conf")
    if os.path.isfile(p):
        for ln in open(p, encoding="utf-8", errors="replace"):
            ln = ln.strip()
            if "=" in ln and not ln.startswith("#"):
                k, v = ln.split("=", 1)
                d[k.strip()] = v.strip().strip('"').strip("'")
    return d


def is_practice():
    # Aids (Hint/Solution/Check) are available in PRACTICE contexts only:
    #   practice <exam> (practice.flag), practice <category>/weak, troubleshoot, master.
    # NOT in a real exam ('start'), a mock, or a drill (timed challenges, aid-free).
    if os.path.exists(os.path.join(ARGS.state, "practice.flag")):
        return True
    ex = str(load_session().get("exam", ""))
    return ex.startswith("practice-") and not ex.startswith("practice-drill")


def is_controller():
    return bool(load_session().get("paper"))


def paper(sess=None):
    """Ordered list of {id, node, num} — from the two-node paper, or single node."""
    sess = sess if sess is not None else load_session()
    if sess.get("paper"):
        items = [{"id": e["id"], "node": e.get("node", "node1")} for e in sess["paper"]]
    else:
        nr = node_conf().get("NODE_ROLE", "node1")
        items = [{"id": t, "node": nr} for t in sess.get("tasks", [])]
    for i, e in enumerate(items, 1):
        e["num"] = i
    return items


def nodes_in_paper():
    seen = []
    for e in paper():
        if e["node"] not in seen:
            seen.append(e["node"])
    return seen or ["node1"]


def meta(tid):
    m = {"TASK_TITLE": tid, "TASK_DOMAIN": "", "TASK_POINTS": "0"}
    p = os.path.join(ARGS.tasks, tid, "meta.sh")
    if os.path.isfile(p):
        for ln in open(p, encoding="utf-8", errors="replace"):
            mt = re.match(r'\s*(TASK_TITLE|TASK_DOMAIN|TASK_POINTS)=("?)(.*?)\2\s*$', ln.rstrip("\n"))
            if mt:
                m[mt.group(1)] = mt.group(3)
    return m


def prompt_text(tid):
    for p in (os.path.join(ARGS.prompts, tid + ".txt"),
              os.path.join(ARGS.tasks, tid, "prompt.txt")):
        if os.path.isfile(p):
            return open(p, encoding="utf-8", errors="replace").read()
    return "(prompt not available)"


def aid_file(kind, tid):
    base = ARGS.hints if kind == "hint" else ARGS.solutions
    p = os.path.join(base, tid + ".txt")
    if os.path.isfile(p):
        return open(p, encoding="utf-8", errors="replace").read()
    return None


def solution_html(tid):
    """Render the (already value-substituted) reference solution as readable HTML:
    headings + prose explanations as text, command blocks distinct, and the inline
    explanatory comments (#...) highlighted -- so it reads as a worked solution with
    explanations, not a bare command dump."""
    txt = aid_file("solution", tid)
    if txt is None:
        txt, _ = run_cli(["solution", tid])
    if not txt or not txt.strip():
        return "<p class='solp'>(no reference solution for this task)</p>"
    esc = html.escape
    out = []
    for i, seg in enumerate(txt.split("```")):
        if i % 2 == 1:                                   # fenced command block
            seg = re.sub(r"^bash\n?", "", seg).rstrip("\n")
            lines = []
            for l in seg.split("\n"):
                if re.match(r"^\s*#", l):                # whole-line explanatory comment
                    lines.append("<span class='c'>%s</span>" % esc(l))
                else:
                    u = re.match(r"^(.*?)(\s#\s.*)$", l)  # trailing explanatory comment
                    if u:
                        lines.append(esc(u.group(1)) + "<span class='c'>" + esc(u.group(2)) + "</span>")
                    else:
                        lines.append(esc(l))
            out.append("<pre class='cmd'>%s</pre>" % "\n".join(lines))
        else:                                            # prose / headings
            for l in seg.split("\n"):
                if not l.strip():
                    continue
                hm = re.match(r"^#+\s*(.*)$", l)
                out.append(("<p class='solh'>%s</p>" % esc(hm.group(1))) if hm
                           else ("<p class='solp'>%s</p>" % esc(l)))
    return "\n".join(out) or "<p class='solp'>(empty)</p>"


def load_marks():
    try:
        return json.load(open(os.path.join(ARGS.state, "marks.json"), encoding="utf-8"))
    except Exception:
        return {}


def save_marks(m):
    try:
        json.dump(m, open(os.path.join(ARGS.state, "marks.json"), "w", encoding="utf-8"))
    except Exception:
        pass


def run_cli(args, timeout=180):
    """Run the rhcsa-sim CLI; return (clean_text, rc)."""
    try:
        r = subprocess.run([ARGS.bin] + list(args), capture_output=True, text=True,
                           timeout=timeout, stdin=subprocess.DEVNULL)
        return ANSI.sub("", (r.stdout or "") + (r.stderr or "")), r.returncode
    except Exception as e:
        return "(error running rhcsa-sim %s: %s)" % (" ".join(args), e), 1


def _run1(cmd, timeout=5):
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout).stdout.strip()
    except Exception:
        return ""


def dns_domain():
    return _run1(["hostname", "-d"]) or "example.com"


def host_fqdn(node):
    # Dynamic: this system's real FQDN (hostname -f); the peer's FQDN resolved from
    # the configured peer IP. Falls back to <node>.<actual-domain> -- never a
    # hardcoded domain -- so it reflects whoever installed the simulator.
    nc = node_conf()
    if node == nc.get("NODE_ROLE", "node1"):
        return _run1(["hostname", "-f"]) or _run1(["hostname"]) or ("%s.%s" % (node, dns_domain()))
    pip = nc.get("PEER_IP", "")
    if pip:
        g = _run1(["getent", "hosts", pip]).split()
        if len(g) >= 2:
            return g[1]
    return "%s.%s" % (node, dns_domain())


def local_ip():
    out = _run1(["hostname", "-I"]).split()
    return out[0] if out else (node_conf().get("SELF_IP") or "?")


def peer_ip(node):
    nc = node_conf()
    if nc.get("PEER_IP"):
        return nc["PEER_IP"]
    g = _run1(["getent", "hosts", host_fqdn(node)]).split()
    return g[0] if g else "?"


def subnet():
    # The network/netmask of this system's primary IP, like the real exam's
    # "172.24.14.0/255.255.255.0" -- derived dynamically, never hardcoded.
    ip = local_ip()
    try:
        import ipaddress
        for ln in _run1(["ip", "-o", "-f", "inet", "addr", "show"]).splitlines():
            for w in ln.split():
                if "/" in w and w.split("/")[0] == ip:
                    net = ipaddress.ip_network(w, strict=False)
                    return "%s/%s" % (net.network_address, net.netmask)
    except Exception:
        pass
    return ""


def access_conf():
    d = {}
    p = os.path.join(ARGS.state, "access.conf")
    if os.path.isfile(p):
        for ln in open(p, encoding="utf-8", errors="replace"):
            if "=" in ln and not ln.startswith("#"):
                k, v = ln.split("=", 1)
                d[k.strip()] = v.strip().strip('"').strip("'")
    return d


# ------------------------------------------------------------------------- HTML
CSS = """
* { box-sizing: border-box; }
body { margin:0; font-family: Georgia,'Times New Roman',serif; color:#111; background:#f4f3e2; }
#wrap { display:flex; min-height:100vh; }
#side { width:230px; min-width:230px; background:#fff; border-right:1px solid #ccc;
        padding:18px 14px; text-align:center; }
#side .logo { margin:4px auto 6px; }
#side h1 { font-size:26px; line-height:1.05; margin:6px 0 14px; font-weight:bold; color:#111; }
.timer { display:block; margin:0 0 12px; padding:7px 6px; font-size:15px;
         background:#ffffcc; border:1px solid #e89; border-radius:2px; text-align:left; }
.timer.low { color:#b00; font-weight:bold; border-color:#b00; }
#side a, .main a { color:#1a0dab; }
.lang { font-size:14px; }
.count { color:#555; font-size:12px; margin-top:10px; }
.main { flex:1; padding:22px 30px; max-width:900px; }
.main h2 { font-size:20px; margin:0 0 6px; }
.main p.intro { margin:4px 0 10px; }
hr { border:0; border-top:1px solid #cfcfb8; margin:16px 0; }
.host { font-weight:bold; font-size:17px; margin:14px 0 8px; background:#fcfce8;
        border:1px solid #ddd9b8; padding:6px 10px; }
.host code { font-family:'DejaVu Sans Mono',monospace; font-weight:bold; }
.row { padding:5px 2px; }
.row label { margin-right:10px; font-size:13px; color:#444; }
.row a { font-size:16px; }
.biglink { font-size:18px; font-weight:bold; }
pre { background:#fbfbf0; border:1px solid #ddd; padding:12px; white-space:pre-wrap;
      font-family:'DejaVu Sans Mono',monospace; font-size:14px; line-height:1.4; }
.cmd { background:#fbfbf0; border:1px solid #ddd; border-left:4px solid #cc0000; padding:10px 12px;
       white-space:pre-wrap; font-family:'DejaVu Sans Mono',monospace; font-size:14px; line-height:1.5; margin:8px 0; }
.cmd .c { color:#6a8a3a; }            /* explanatory comments shown alongside the commands */
.solh { font-weight:bold; font-size:16px; margin:12px 0 4px; }
.solp { margin:6px 0; line-height:1.5; }
.btn { display:inline-block; margin:6px 8px 6px 0; padding:8px 16px; font-size:14px;
       font-family:Georgia,serif; background:#eee; border:1px solid #999; border-radius:4px;
       cursor:pointer; color:#111; text-decoration:none; }
.btn:hover { background:#e0e0e0; }
.btn.red { background:#cc0000; color:#fff; border-color:#a00; }
.btn.warn { background:#ffd9d9; border-color:#c66; }
.vmcard { display:inline-block; width:150px; height:96px; margin:10px; vertical-align:top;
          border:1px solid #999; border-radius:6px; background:#f0f0f0; font-size:18px;
          cursor:pointer; }
.vmcard:hover { background:#e6e6e6; }
.note { color:#666; font-size:13px; }
#out { margin-top:14px; }
.done { color:#0a0; } .revisit { color:#c80; }
"""

SHADOWMAN = """<svg class="logo" viewBox="0 0 120 86" width="104" height="74" aria-label="Red Hat">
  <ellipse cx="60" cy="70" rx="54" ry="12" fill="#cc0000"/>
  <path d="M18 66 C20 34 38 22 60 22 C82 22 100 34 102 66 C82 58 38 58 18 66 Z" fill="#ee0000"/>
  <path d="M30 30 C40 16 80 16 90 30 C78 24 42 24 30 30 Z" fill="#cc0000"/>
  <ellipse cx="60" cy="64" rx="40" ry="6" fill="#a30000"/>
</svg>"""


def sidebar(sess):
    p = paper(sess)
    # English-only content; render a real (single-option) selector instead of a
    # dead link so it shows an option and never looks broken.
    lang = ('<span class="lang">Select Language: '
            '<select onchange="this.selectedIndex=0"><option>English</option></select></span>')
    return """<div id="side">
  %s
  <h1>Red Hat<br>Test Exam</h1>
  <span class="timer" id="timer">Time remaining: --:--</span>
  %s
  <div class="count">%d task%s</div>
  <div class="count"><a href="/">Exam paper</a> · <a href="/vm">VM control</a></div>
  <div class="count"><a href="/grade">Grade</a> · <a href="/report">Report</a> · <a href="/stats">Stats</a></div>
</div>""" % (SHADOWMAN, lang, len(p), "" if len(p) == 1 else "s")


def timer_js(sess):
    start = int(sess.get("start", 0) or 0)
    dur = int(sess.get("duration", 0) or 0)
    return """<script>
var END=%d, NOW0=%d, T0=Date.now()/1000;
function fmt(s){ if(s<=0) return "Time's up"; s=Math.floor(s);
  var h=Math.floor(s/3600), m=Math.floor((s%%3600)/60), sec=s%%60, p=function(n){return(n<10?'0':'')+n;};
  return (s<300)? (m+':'+p(sec)) : (h+':'+p(m)); }
function tick(){ var rem=END-NOW0-(Date.now()/1000-T0); var el=document.getElementById('timer');
  if(!el) return; el.textContent='Time remaining: '+fmt(rem); el.className=(rem<300)?'timer low':'timer'; }
setInterval(tick,1000); tick();
function postMark(id,st){ fetch('/api/mark',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},
  body:'id='+encodeURIComponent(id)+'&state='+st}); }
</script>""" % ((start + dur), int(time.time()))


def page(title, sess, body):
    return ("<!doctype html><html><head><meta charset='utf-8'><title>%s</title>"
            "<style>%s</style></head><body><div id='wrap'>%s<div class='main'>%s</div></div>%s"
            "</body></html>") % (html.escape(title), CSS, sidebar(sess), body, timer_js(sess))


def report_ready_banner():
    """Surface the reboot-grade result on the exam paper. Three states:
      report-ready.flag   -> graded: link to the scored report.
      report-pending.flag -> grade still running after the reboot (can take ~2 min
                             two-node): show progress + auto-refresh so the result
                             appears on its own.
      neither             -> nothing.
    Without this the paper showed no result until the grade finished, which is the
    race the user hit (logged in before the post-reboot grade completed)."""
    try:
        if os.path.exists(os.path.join(ARGS.state, "report-ready.flag")):
            return ("<div style='background:#e6f4ea;border:1px solid #4a9a5e;"
                    "padding:11px 14px;margin-bottom:14px;border-radius:3px;font-size:15px;'>"
                    "&#9989; <b>Your exam has been graded</b> (persistence checked after the "
                    "reboot). <a class='biglink' href='/report'>View your scored report "
                    "&rarr;</a></div>")
        if os.path.exists(os.path.join(ARGS.state, "report-pending.flag")):
            return ("<div style='background:#fff3cd;border:1px solid #d9a900;"
                    "padding:11px 14px;margin-bottom:14px;border-radius:3px;font-size:15px;'>"
                    "&#8987; <b>Grading after the reboot &mdash; in progress&hellip;</b> "
                    "This takes a minute or two (the peer node is graded too). The page "
                    "refreshes automatically; the score appears here when it is ready."
                    "<script>setTimeout(function(){location.reload();},8000);</script></div>")
    except Exception:
        pass
    return ""


def exam_page():
    sess = load_session()
    pr = paper(sess)
    marks = load_marks()
    practice = is_practice()
    banner = ("<div style='background:#e8f5e9;border:1px solid #88aa88;padding:9px 13px;"
              "margin-bottom:14px;border-radius:3px;font-size:14px;'><b>Practice mode</b> — "
              "learning aids are on. Open any task for <b>Hint</b>, <b>Solution</b> and "
              "<b>Check my work</b> (a real exam, mock or drill stays aid-free).</div>") if practice else ""
    body = [report_ready_banner(), banner, "<h2>Configuration Information</h2>",
            "<p class='intro'>Before you begin, you should review some general configuration "
            "information outlined in the following link:</p>",
            "<div class='row'>%s <a class='biglink' href='/config'>Important configuration "
            "information</a></div>" % radios("config", marks.get("config", ""))]
    # group tasks by node, in paper order
    last = None
    for e in pr:
        if e["node"] != last:
            body.append("<hr>")
            body.append("<div class='host'>Perform the following tasks on "
                        "<code>%s</code>.</div>" % html.escape(host_fqdn(e["node"])))
            last = e["node"]
        nn = "%02d" % e["num"]
        if practice:
            m = meta(e["id"])
            label = "%s. %s &nbsp;<span class='note'>[%s, %s pts]</span>" % (
                nn, html.escape(m["TASK_TITLE"]), html.escape(m["TASK_DOMAIN"]), html.escape(m["TASK_POINTS"]))
        else:
            label = "Configure your system %s" % nn
        body.append("<div class='row'>%s <a href='/task?id=%s'>%s</a></div>" % (
            radios(e["id"], marks.get(e["id"], "")), urllib.parse.quote(e["id"]), label))
    return page("Red Hat Test Exam", sess, "".join(body))


def radios(key, state=""):
    rv = "checked" if state == "revisit" else ""
    dn = "checked" if state == "done" else ""
    g = "mark_" + key
    return ("<label><input type='radio' name='%s' value='revisit' %s "
            "onclick=\"postMark('%s','revisit')\"> Revisit</label>"
            "<label><input type='radio' name='%s' value='done' %s "
            "onclick=\"postMark('%s','done')\"> Done</label>") % (g, rv, key, g, dn, key)


def config_page():
    sess = load_session()
    nc = node_conf()
    ns = nodes_in_paper()
    pr = paper(sess)
    esc = html.escape
    n1role = nc.get("NODE_ROLE", "node1")
    peers = [n for n in ns if n != n1role]

    def tasks_on(node):
        return [e["id"] for e in pr if e["node"] == node]

    n1_fqdn, n1_ip = esc(host_fqdn(n1role)), esc(local_ip())
    dom, net = esc(dns_domain()), esc(subnet())
    th = "border:1px solid #b0a98f;padding:6px 18px;text-align:left;background:#efe9d6"
    td = "border:1px solid #b0a98f;padding:6px 18px;font-family:monospace"

    rows = ["<h2>Important configuration information</h2>",
            "<p class='intro'>During the exam you work with the virtual system(s) listed below; "
            "you have full root access to them.</p>",
            "<h3>System Information</h3>",
            "<table style='border-collapse:collapse;margin:10px 0;background:#fff'>",
            "<tr><th style='%s'>System</th><th style='%s'>IP Address</th></tr>" % (th, th),
            "<tr><td style='%s'>%s</td><td style='%s'>%s</td></tr>" % (td, n1_fqdn, td, n1_ip)]
    for p in peers:
        rows.append("<tr><td style='%s'>%s</td><td style='%s'>%s</td></tr>"
                    % (td, esc(host_fqdn(p)), td, esc(peer_ip(p))))
    rows.append("</table>")
    dommsg = "The systems are members of the DNS domain <b>%s</b>" % dom
    if net:
        dommsg += ", and all systems are in the <b>%s</b> subnet" % net
    rows.append("<p>%s. The IP addresses listed are the addresses that <b>should</b> be assigned "
                "to the systems; you may need to configure the network to reach them.</p>" % dommsg)

    # ---- Account Information: root password for node1 only (node2 is reset by you) ----
    rows.append("<h3>Account Information</h3>")
    ac = access_conf()
    fresh = str(ac.get("SESSION_START", "")) == str(sess.get("start", ""))
    n1_pw = ac.get("NODE1_ROOTPW", "") if fresh else ""
    n1_reset = "root-password" in tasks_on(n1role)
    if n1_pw and not n1_reset:
        rows.append("<p>The <b>root</b> password for %s has been set to <b>&quot;%s&quot;</b>. "
                    "Unless otherwise specified, this is the password you use for other accounts "
                    "you create and for services that require a password.</p>" % (n1_fqdn, esc(n1_pw)))
    elif n1_reset:
        rows.append("<p>The <b>root</b> password for %s is <b>not provided</b> &mdash; you must "
                    "reset it as instructed (see the <i>Reset Root Password</i> task).</p>" % n1_fqdn)
    else:
        rows.append("<p>Log in to %s as <b>student</b> / <b>password</b> and become root with "
                    "<code>sudo -i</code>.</p>" % n1_fqdn)
    for p in peers:
        pf = esc(host_fqdn(p))
        if "root-password" in tasks_on(p):
            rows.append("<p>The <b>root</b> password for %s is <b>not provided</b> &mdash; you must "
                        "reset it yourself as instructed (the <i>Reset Root Password</i> task on %s).</p>"
                        % (pf, pf))
    reach = ""
    if peers:
        pf0 = esc(host_fqdn(peers[0]))
        reach = (" Reach %s with <code>ssh student@%s</code> then <code>sudo -i</code> "
                 "(root SSH may be disabled by a task &mdash; use student + sudo).") % (pf0, pf0)
    rows.append("<p>Log in as <b>student</b> / <b>password</b>; become root with "
                "<code>sudo -i</code>.%s</p>" % reach)

    # ---- Other Information ----
    rows.append("<h3>Other Information</h3>")
    rows.append("<p>You may access the systems via SSH or the console. Packages install "
                "<b>offline</b> from the attached DVD repository. After completing a task you may "
                "<b>reboot</b> a system to verify your changes persist, then reopen this exam with "
                "<code>rhcsa-sim tui</code> &mdash; your progress and the remaining time are preserved. "
                "When you are finished, grade with <code>rhcsa-sim grade --reboot</code> "
                "(pass mark <b>210/300</b>).</p>")
    rows.append("<p><a class='btn' href='/'>&larr; Back to exam paper</a></p>")
    return page("Configuration Information", sess, "\n".join(rows))


def task_page(tid):
    sess = load_session()
    pr = paper(sess)
    ent = next((e for e in pr if e["id"] == tid), None)
    if not ent:
        return page("Task", sess, "<h2>Unknown task</h2><p>'%s' is not in this exam.</p>"
                    "<p><a class='btn' href='/'>&larr; Back</a></p>" % html.escape(tid))
    m = meta(tid)
    practice = is_practice()
    nn = "%02d" % ent["num"]
    head = ("%s. %s <span class='note'>[%s, %s pts]</span>" % (
        nn, html.escape(m["TASK_TITLE"]), html.escape(m["TASK_DOMAIN"]), html.escape(m["TASK_POINTS"]))
        if practice else "Configure your system %s" % nn)
    body = ["<h2>%s</h2>" % head,
            "<p class='note'>Perform on <code>%s</code></p>" % html.escape(host_fqdn(ent["node"])),
            "<pre>%s</pre>" % html.escape(prompt_text(tid))]
    body.append("<div class='row'>Mark: %s</div>" % radios(tid, load_marks().get(tid, "")))
    if practice:
        body.append(
            "<p><button class='btn' onclick=\"aid('hint')\">Hint</button>"
            "<button class='btn' onclick=\"aid('solution')\">Solution</button>"
            "<button class='btn red' onclick=\"chk()\">Check my work</button></p>"
            "<div id='out'></div>"
            "<script>var TID=%s;"
            "function show(t){document.getElementById('out').innerHTML='<pre>'+t.replace(/&/g,'&amp;').replace(/</g,'&lt;')+'</pre>';}"
            "function aid(k){show('Loading ...');fetch('/api/aid',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},"
            "body:'id='+encodeURIComponent(TID)+'&kind='+k}).then(r=>r.text()).then(function(t){"
            "if(k=='solution'){document.getElementById('out').innerHTML=t;}else{show(t);}});}"
            "function chk(){show('Checking ...');fetch('/api/check',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},"
            "body:'id='+encodeURIComponent(TID)}).then(r=>r.text()).then(show);}</script>"
            % json.dumps(tid))
    else:
        body.append("<p class='note'>(Exam mode — no answers or self-check, like the real exam. "
                    "Use a terminal to do the task, then grade when finished.)</p>")
    body.append("<p><a class='btn' href='/'>&larr; Back to exam paper</a></p>")
    return page("Task %s" % nn, sess, "".join(body))


def vm_page():
    sess = load_session()
    ns = nodes_in_paper()
    cards = "".join("<button class='vmcard' onclick=\"pick('%s')\">%s</button>" % (n, n) for n in ns)
    body = """<h2>Select a VM to control</h2>
<div id='pick'>%s</div>
<div id='menu' style='display:none'></div>
<div id='out'></div>
<script>
var NODE=null;
var ACTS=['Status','Start','Reboot','Shutdown','Hard Reboot','Console','Rebuild'];
function out(t){ document.getElementById('out').innerHTML='<pre>'+t.replace(/&/g,'&amp;').replace(/</g,'&lt;')+'</pre>'; }
function pick(n){
  NODE=n;
  var h='<h2>'+n+'</h2>';
  for(var i=0;i<ACTS.length;i++){ var a=ACTS[i];
    var cls=(a=='Rebuild')?'btn red':((a=='Shutdown'||a=='Hard Reboot')?'btn warn':'btn');
    h+='<button class="'+cls+'" data-act="'+a+'">'+a+' '+n+' VM</button>'; }
  h+='<br><button class="btn" data-act="__close">Close</button>';
  var menu=document.getElementById('menu');
  menu.innerHTML=h; menu.style.display='block'; document.getElementById('out').innerHTML='';
  var btns=menu.getElementsByTagName('button');
  for(var j=0;j<btns.length;j++){ btns[j].onclick=function(){ act(this.getAttribute('data-act')); }; }
}
function act(a){
  if(a=='__close'){ document.getElementById('menu').style.display='none'; document.getElementById('out').innerHTML=''; return; }
  var action=a.toLowerCase().replace(' ','-'); var extra='';
  if(a=='Rebuild'||a=='Reboot'||a=='Hard Reboot'||a=='Shutdown'){
    var msg=(a=='Rebuild')?('Rebuild '+NODE+" will ERASE all your work on it and restore the exam's initial state.")
            :(a+' '+NODE+'. If this is the system you are using, it ends your current exam view'+((a=='Shutdown')?' and the node must be powered back on from your hypervisor (it cannot be started from inside the exam)':'')+'.');
    var c=prompt(msg+'\\nType CONFIRM (all caps) to proceed:');
    if(c!=='CONFIRM'){ out('cancelled'); return; }
    extra='&confirm=CONFIRM';
  }
  out(a+' '+NODE+' ...');
  fetch('/api/vm',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},
    body:'node='+encodeURIComponent(NODE)+'&action='+action+extra}).then(function(r){return r.text();}).then(out);
}
</script>
<p class='note'>Console opens a terminal SSH session to the node; Rebuild restores the node to
the exam's initial state (your work on it is erased).</p>
<p><a class='btn' href='/'>&larr; Back to exam paper</a></p>""" % cards
    return page("Select a VM to control", sess, body)


def report_page():
    sess = load_session()
    cmd = ["report", "--combined"] if is_controller() else ["report"]
    out, _ = run_cli(cmd, timeout=180)
    body = ("<h2>Scored report</h2><pre>%s</pre>"
            "<p><a class='btn' href='/grade'>Re-grade</a> "
            "<a class='btn' href='/stats'>Stats</a> "
            "<a class='btn' href='/'>&larr; Back to exam paper</a></p>") % html.escape(
                out or "(nothing graded yet — use Grade first)")
    return page("Report", sess, body)


def stats_page():
    sess = load_session()
    out, _ = run_cli(["stats"], timeout=60)
    body = ("<h2>Your progress (real exams + mock)</h2><pre>%s</pre>"
            "<p><a class='btn' href='/report'>Report</a> "
            "<a class='btn' href='/'>&larr; Back to exam paper</a></p>") % html.escape(out or "(no stats)")
    return page("Stats", sess, body)


def grade_page():
    sess = load_session()
    two = is_controller()
    both = "both nodes" if two else "this system"
    body = """<h2>Grade your exam</h2>
<p>Grade now, or grade after a <b>reboot</b> to prove your configuration persists — exactly how
the real exam is scored.%s</p>
<p><button class='btn' onclick="gradeNow()">Grade now</button>
   <button class='btn red' onclick="gradeReboot()">Grade with reboot (persistence test)</button></p>
<div id='out'></div>
<script>
function out(t){ document.getElementById('out').innerHTML='<pre>'+t.replace(/&/g,'&amp;').replace(/</g,'&lt;')+'</pre>'; }
function gradeNow(){ out('Grading %s ... this can take a minute.');
  fetch('/api/grade',{method:'POST'}).then(function(r){return r.text();}).then(out); }
function gradeReboot(){ if(!confirm('This reboots %s and grades after boot.\\nThe report opens automatically when you log back in. Continue?')) return;
  out('Grading with reboot — %s will reboot shortly.\\nLog back in: the report opens automatically.');
  fetch('/api/grade-reboot',{method:'POST'}); }
</script>
<p><a class='btn' href='/'>&larr; Back to exam paper</a></p>""" % (
        " Both nodes reboot together." if two else "", both, both, both[:1].upper() + both[1:])
    return page("Grade", sess, body)


# --------------------------------------------------------------------- handler
class H(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _send(self, body, ctype="text/html; charset=utf-8", code=200):
        b = body.encode("utf-8") if isinstance(body, str) else body
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(b)))
        self.end_headers()
        try:
            self.wfile.write(b)
        except BrokenPipeError:
            pass

    def do_GET(self):
        u = urllib.parse.urlparse(self.path)
        q = urllib.parse.parse_qs(u.query)
        if u.path == "/":
            self._send(exam_page())
        elif u.path == "/config":
            self._send(config_page())
        elif u.path == "/task":
            self._send(task_page(q.get("id", [""])[0]))
        elif u.path == "/vm":
            self._send(vm_page())
        elif u.path == "/report":
            self._send(report_page())
        elif u.path == "/stats":
            self._send(stats_page())
        elif u.path == "/grade":
            self._send(grade_page())
        elif u.path == "/api/state":
            s = load_session()
            self._send(json.dumps({"start": s.get("start"), "duration": s.get("duration"),
                                   "now": int(time.time()), "practice": is_practice(),
                                   "marks": load_marks()}), "application/json")
        elif u.path == "/favicon.ico":
            self._send(b"", "image/x-icon", 204)
        else:
            self._send("<h1>404</h1>", code=404)

    def _body(self):
        n = int(self.headers.get("Content-Length", 0) or 0)
        return urllib.parse.parse_qs(self.rfile.read(n).decode("utf-8")) if n else {}

    def do_POST(self):
        u = urllib.parse.urlparse(self.path)
        f = self._body()
        one = lambda k: f.get(k, [""])[0]
        if u.path == "/api/mark":
            tid, st = one("id"), one("state")
            m = load_marks()
            if st in ("done", "revisit"):
                m[tid] = st
            else:
                m.pop(tid, None)
            save_marks(m)
            self._send("ok", "text/plain")
        elif u.path == "/api/check":
            if not is_practice():
                self._send("(self-check is a practice aid — exams are graded only with "
                           "'rhcsa-sim grade')", "text/plain"); return
            out, _ = run_cli(["check", one("id")])
            self._send(out or "(no output)", "text/plain")
        elif u.path == "/api/aid":
            if not is_practice():
                self._send("(aids are practice-only)", "text/plain"); return
            kind = one("kind"); tid = one("id")
            if kind == "solution":
                self._send(solution_html(tid), "text/html"); return
            txt = aid_file(kind, tid)
            if txt is None:
                txt, _ = run_cli([kind, tid])
            self._send(txt or "(none)", "text/plain")
        elif u.path == "/api/vm":
            args = ["vm", one("action"), one("node")]
            if one("confirm") == "CONFIRM":
                args.append("--yes")
            out, _ = run_cli(args, timeout=600)
            self._send(out or "(no output)", "text/plain")
        elif u.path == "/api/grade":
            out, _ = run_cli(["grade"], timeout=600)
            self._send(out or "(graded — see Report)", "text/plain")
        elif u.path == "/api/grade-reboot":
            try:
                subprocess.Popen([ARGS.bin, "grade", "--reboot"], stdin=subprocess.DEVNULL,
                                 stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                self._send("Grading with reboot initiated — the system will reboot shortly. "
                           "Log back in and the report opens automatically.", "text/plain")
            except Exception as e:
                self._send("error: %s" % e, "text/plain")
        else:
            self._send("404", "text/plain", 404)


def main():
    global ARGS
    ap = argparse.ArgumentParser()
    ap.add_argument("--session", required=True)
    ap.add_argument("--tasks", required=True)
    ap.add_argument("--prompts", required=True)
    ap.add_argument("--state", required=True)
    ap.add_argument("--hints", default="")
    ap.add_argument("--solutions", default="")
    ap.add_argument("--bin", default="rhcsa-sim")
    ap.add_argument("--port", type=int, default=8200)
    ap.add_argument("--no-browser", action="store_true")
    ARGS = ap.parse_args()

    srv = None
    for port in range(ARGS.port, ARGS.port + 12):
        try:
            srv = ThreadingHTTPServer(("127.0.0.1", port), H)
            ARGS.port = port
            break
        except OSError:
            continue
    if srv is None:
        print("could not bind a port in %d..%d" % (ARGS.port, ARGS.port + 12), file=sys.stderr)
        sys.exit(1)
    url = "http://localhost:%d/" % ARGS.port
    print("\n  RHCSA exam paper (browser):  %s" % url)
    print("  Leave this running; press Ctrl-C to close the exam view.\n")
    disp = os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY")
    if not ARGS.no_browser and disp:
        # The server runs as root (it needs root for check/vm), but a browser must
        # open in the DESKTOP user's session — Firefox-as-root misbehaves. When run
        # via sudo, open as $SUDO_USER with their display; else open directly.
        su = os.environ.get("SUDO_USER")
        opener = None
        if su and su != "root":
            try:
                uid = pwd.getpwnam(su).pw_uid
                env = "DISPLAY=%s XDG_RUNTIME_DIR=/run/user/%d" % (os.environ.get("DISPLAY", ""), uid)
                wd = os.environ.get("WAYLAND_DISPLAY")
                if wd:
                    env += " WAYLAND_DISPLAY=%s" % wd
                opener = ["runuser", "-u", su, "--", "bash", "-c", "%s xdg-open '%s'" % (env, url)]
            except Exception:
                opener = None
        if opener is None:
            opener = ["xdg-open", url]
        try:
            subprocess.Popen(opener, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except Exception:
            try:
                webbrowser.open(url)
            except Exception:
                pass
    else:
        print("  (No graphical display detected — open the URL above in node1's browser.)\n")
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        print("\n  exam view closed.")
        srv.shutdown()


if __name__ == "__main__":
    main()
