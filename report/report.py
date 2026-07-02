#!/usr/bin/env python3
"""Aggregate task checkpoint results into a scored RHCSA report.

Reads:
  --session  session.json  (exam, start, duration, tasks[])
  --tasks    tasks/ dir     (each <id>/meta.sh + prompt.txt)
  --results  results/ dir   (each <id>.jsonl of checkpoint objects)
Writes a text report to stdout and JSON (+optional HTML) to --reports.

Scoring model (exam-accurate):
  * A task earns its FULL points only if every checkpoint passed (binary),
    exactly like the real exam grades an objective.
  * The per-checkpoint breakdown is shown for learning, plus a "partial"
    score so candidates see how close they were.
  * Exam total is normalised to 300; pass mark default 70% (210/300).
"""
import argparse, json, os, re, sys, time, html, datetime

C = dict(red="\033[31m", grn="\033[32m", yel="\033[33m", blu="\033[34m",
         bold="\033[1m", dim="\033[2m", off="\033[0m")
def col(s, c): return f"{C[c]}{s}{C['off']}" if sys.stdout.isatty() else str(s)

META_RE = re.compile(r'^\s*(TASK_TITLE|TASK_DOMAIN|TASK_POINTS)\s*=\s*"?([^"#\n]*)"?', re.M)

def load_meta(tasks_dir, tid):
    m = {"TASK_TITLE": tid, "TASK_DOMAIN": "misc", "TASK_POINTS": "0"}
    p = os.path.join(tasks_dir, tid, "meta.sh")
    if os.path.isfile(p):
        for k, v in META_RE.findall(open(p, encoding="utf-8", errors="replace").read()):
            m[k] = v.strip()
    return m

def load_checkpoints(results_dir, tid):
    p = os.path.join(results_dir, tid + ".jsonl")
    cps = []
    if os.path.isfile(p):
        for line in open(p, encoding="utf-8", errors="replace"):
            line = line.strip()
            if not line:
                continue
            try:
                cps.append(json.loads(line))
            except json.JSONDecodeError:
                pass
    return cps

def grade(session, tasks_dir, results_dir, pass_pct):
    sess = json.load(open(session))
    tasks = sess.get("tasks", [])
    rows = []
    total_max = earned_binary = partial_sum = partial_max = 0
    domain_stat = {}
    for tid in tasks:
        meta = load_meta(tasks_dir, tid)
        cps = load_checkpoints(results_dir, tid)
        cp_max = sum(int(c.get("max", 0)) for c in cps)
        cp_got = sum(int(c.get("points", 0)) for c in cps if c.get("ok"))
        # task max: prefer declared points if checkpoints absent
        tmax = cp_max or int(meta["TASK_POINTS"] or 0)
        graded = len(cps) > 0
        all_ok = graded and all(c.get("ok") for c in cps)
        binval = tmax if all_ok else 0
        total_max += tmax
        earned_binary += binval
        partial_sum += cp_got
        partial_max += (cp_max or tmax)
        d = meta["TASK_DOMAIN"]
        ds = domain_stat.setdefault(d, [0, 0])
        ds[0] += binval; ds[1] += tmax
        rows.append(dict(id=tid, title=meta["TASK_TITLE"], domain=d,
                         max=tmax, binary=binval, cp_got=cp_got, cp_max=cp_max,
                         all_ok=all_ok, graded=graded, checkpoints=cps))
    score300 = round(earned_binary / total_max * 300) if total_max else 0
    pct = (earned_binary / total_max * 100) if total_max else 0
    passed = pct >= pass_pct
    return dict(exam=sess.get("exam"), start=sess.get("start"),
                duration=sess.get("duration"), rows=rows,
                total_max=total_max, earned_binary=earned_binary,
                partial_sum=partial_sum, partial_max=partial_max,
                score300=score300, pct=round(pct, 1), passed=passed,
                pass_pct=pass_pct, domain_stat=domain_stat,
                graded_at=int(time.time()))

def fmt_time(secs):
    secs = max(0, int(secs)); return f"{secs//3600:02d}:{(secs%3600)//60:02d}:{secs%60:02d}"

def print_text(r):
    print(); print(col("=" * 64, "bold"))
    print(col(f"  RHCSA EX200 SIMULATOR — RESULT REPORT", "bold"))
    print(col("=" * 64, "bold"))
    print(f"  Exam: {r['exam']}    Graded: "
          f"{datetime.datetime.fromtimestamp(r['graded_at']):%Y-%m-%d %H:%M:%S}")
    if r["start"]:
        used = r["graded_at"] - int(r["start"])
        over = used > int(r["duration"])
        t = fmt_time(used) + (col("  (OVER TIME)", "red") if over else "")
        print(f"  Time used: {t}  of {fmt_time(r['duration'])}")
    print(col("-" * 64, "dim"))
    for row in r["rows"]:
        if not row["graded"]:
            verdict = col("NOT GRADED", "yel")
        elif row["all_ok"]:
            verdict = col("PASS", "grn")
        else:
            verdict = col("FAIL", "red")
        print(f"{col(row['id'],'bold'):<32} "
              f"[{row['binary']:>3}/{row['max']:<3}] {verdict}   {col(row['domain'],'dim')}")
        print(f"    {row['title']}")
        for c in row["checkpoints"]:
            mark = col("✓", "grn") if c.get("ok") else col("✗", "red")
            line = f"      {mark} {c.get('checkpoint','')}  ({c.get('points',0)}/{c.get('max',0)})"
            if not c.get("ok") and c.get("detail"):
                line += col(f"   [{c['detail']}]", "dim")
            print(line)
    print(col("-" * 64, "dim"))
    # Domain breakdown
    print(col("  Domain breakdown:", "bold"))
    for d, (g, m) in sorted(r["domain_stat"].items(), key=lambda x: (x[1][0]/x[1][1] if x[1][1] else 0)):
        p = (g / m * 100) if m else 0
        bar = "█" * int(p // 10) + "·" * (10 - int(p // 10))
        c = "grn" if p >= 70 else ("yel" if p >= 40 else "red")
        print(f"    {d:<16} {col(bar,c)} {g:>3}/{m:<3} ({p:4.0f}%)")
    print(col("-" * 64, "dim"))
    big = "PASS" if r["passed"] else "FAIL"
    bc = "grn" if r["passed"] else "red"
    print(f"  {col('FINAL SCORE','bold')}: "
          f"{col(str(r['score300'])+'/300','bold')}  ({r['pct']}%)   "
          f"need {round(3*r['pass_pct'])}/300 to pass   "
          f"=> {col(big, bc)}")
    print(f"  {col('checkpoint partial','dim')}: {r['partial_sum']}/{r['partial_max']} "
          f"{col('(learning aid; not the exam score)','dim')}")
    print(col("=" * 64, "bold")); print()

HTML_TPL = """<!doctype html><html><head><meta charset="utf-8">
<title>RHCSA Simulator Report</title><style>
body{{font-family:system-ui,Segoe UI,Roboto,sans-serif;margin:2rem;color:#1a1a2e;background:#f7f8fb}}
h1{{color:#0b3d91}} .verdict{{font-size:1.6rem;font-weight:700;padding:.4rem 1rem;border-radius:.5rem;display:inline-block}}
.pass{{background:#d6f5d6;color:#0a7a0a}} .fail{{background:#fbd6d6;color:#a30000}}
table{{border-collapse:collapse;width:100%;margin:1rem 0;background:#fff}}
th,td{{border:1px solid #e1e4ea;padding:.45rem .6rem;text-align:left;font-size:.92rem}}
th{{background:#0b3d91;color:#fff}} tr.fail td{{background:#fff6f6}} tr.pass td{{background:#f4fff4}}
.cp{{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:.85rem;color:#444;margin:.1rem 0}}
.ok{{color:#0a7a0a}} .no{{color:#a30000}} .bar{{height:.8rem;background:#e1e4ea;border-radius:4px;overflow:hidden;width:160px;display:inline-block;vertical-align:middle}}
.fill{{height:100%}} .meta{{color:#555}}</style></head><body>
<h1>RHCSA EX200 Simulator — Report</h1>
<p class="meta">Exam <b>{exam}</b> · graded {graded} · time used {used} of {dur}</p>
<p><span class="verdict {vcls}">{score}/300 &nbsp; {verdict}</span>
&nbsp; {pct}% (need {need}/300) · checkpoint partial {psum}/{pmax}</p>
<h2>Tasks</h2><table><tr><th>#</th><th>Task</th><th>Domain</th><th>Score</th><th>Result</th><th>Checkpoints</th></tr>
{rows}
</table>
<h2>Domain breakdown</h2><table><tr><th>Domain</th><th>Score</th><th></th></tr>{domains}</table>
</body></html>"""

def write_outputs(r, reports_dir):
    os.makedirs(reports_dir, exist_ok=True)
    stamp = datetime.datetime.fromtimestamp(r["graded_at"]).strftime("%Y%m%d-%H%M%S")
    json.dump(r, open(os.path.join(reports_dir, f"report-{stamp}.json"), "w"), indent=2)
    return stamp

def write_html(r, reports_dir, stamp):
    rows_html = []
    for i, row in enumerate(r["rows"], 1):
        cls = "pass" if row["all_ok"] else ("fail" if row["graded"] else "")
        cps = "".join(
            f'<div class="cp"><span class="{ "ok" if c.get("ok") else "no" }">'
            f'{ "✓" if c.get("ok") else "✗" }</span> {html.escape(str(c.get("checkpoint","")))} '
            f'({c.get("points",0)}/{c.get("max",0)})'
            f'{ "" if c.get("ok") or not c.get("detail") else " — "+html.escape(str(c["detail"])) }</div>'
            for c in row["checkpoints"])
        verdict = "PASS" if row["all_ok"] else ("FAIL" if row["graded"] else "—")
        rows_html.append(
            f'<tr class="{cls}"><td>{i}</td><td><b>{html.escape(row["id"])}</b><br>'
            f'<span class="meta">{html.escape(row["title"])}</span></td>'
            f'<td>{html.escape(row["domain"])}</td><td>{row["binary"]}/{row["max"]}</td>'
            f'<td>{verdict}</td><td>{cps}</td></tr>')
    doms = []
    for d, (g, m) in sorted(r["domain_stat"].items()):
        p = (g / m * 100) if m else 0
        c = "#0a7a0a" if p >= 70 else ("#c98a00" if p >= 40 else "#a30000")
        doms.append(f'<tr><td>{html.escape(d)}</td><td>{g}/{m} ({p:.0f}%)</td>'
                    f'<td><span class="bar"><span class="fill" style="width:{p:.0f}%;background:{c}"></span></span></td></tr>')
    used = (r["graded_at"] - int(r["start"])) if r["start"] else 0
    out = HTML_TPL.format(
        exam=html.escape(str(r["exam"])),
        graded=datetime.datetime.fromtimestamp(r["graded_at"]).strftime("%Y-%m-%d %H:%M"),
        used=fmt_time(used), dur=fmt_time(r["duration"]),
        vcls="pass" if r["passed"] else "fail",
        score=r["score300"], verdict="PASS" if r["passed"] else "FAIL",
        pct=r["pct"], need=round(3 * r["pass_pct"]),
        psum=r["partial_sum"], pmax=r["partial_max"],
        rows="\n".join(rows_html), domains="\n".join(doms))
    path = os.path.join(reports_dir, f"report-{stamp}.html")
    open(path, "w", encoding="utf-8").write(out)
    return path

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--session", required=True)
    ap.add_argument("--tasks", required=True)
    ap.add_argument("--results", required=True)
    ap.add_argument("--reports", required=True)
    ap.add_argument("--pass", dest="passpct", type=float, default=70.0)
    ap.add_argument("--html", action="store_true")
    ap.add_argument("--json", action="store_true", help="print a one-line summary as JSON (for --combined)")
    ap.add_argument("--label", default="", help="role/node label for JSON output")
    a = ap.parse_args()
    r = grade(a.session, a.tasks, a.results, a.passpct)
    if a.json:
        import json as _j
        print(_j.dumps({"label": a.label, "exam": r["exam"],
                        "earned": r["earned_binary"], "max": r["total_max"],
                        "score300": r["score300"], "pct": r["pct"], "passed": r["passed"]}))
        sys.exit(0 if r["passed"] else 2)
    print_text(r)
    stamp = write_outputs(r, a.reports)
    if a.html:
        p = write_html(r, a.reports, stamp)
        print(col(f"  HTML report: {p}", "blu"))
    sys.exit(0 if r["passed"] else 2)

if __name__ == "__main__":
    main()
