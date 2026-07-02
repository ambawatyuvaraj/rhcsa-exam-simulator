#!/usr/bin/env python3
"""RHCSA simulator exam paper — curses TUI (Python stdlib only).

Left pane: numbered task list with mark-for-review flags + time remaining.
Right pane: scrollable text of the selected task.
Keys: ↑/↓ or j/k select · PgUp/PgDn or u/d scroll text · m mark · r refresh
      q quit (exam keeps running in the background).
PRACTICE sessions additionally offer:  h hint · s solution · c check my work
(exam sessions stay aid-free, like the real exam's "Exam View").

The TUI is read-only: candidates do the work in a separate shell/SSH session,
exactly like the real exam's "Exam View" window.
"""
import argparse, curses, json, os, re, subprocess, textwrap, time

ANSI_RE = re.compile(r'\x1b\[[0-9;]*m')

META_RE = re.compile(r'^\s*(TASK_TITLE|TASK_DOMAIN|TASK_POINTS)\s*=\s*"?([^"#\n]*)"?', re.M)

def load_meta(tasks_dir, tid):
    m = {"TASK_TITLE": tid, "TASK_DOMAIN": "misc", "TASK_POINTS": "0"}
    p = os.path.join(tasks_dir, tid, "meta.sh")
    if os.path.isfile(p):
        for k, v in META_RE.findall(open(p, encoding="utf-8", errors="replace").read()):
            m[k] = v.strip()
    return m

def load_prompt(tasks_dir, tid, prompts_dir=None):
    # Prefer the per-session rendered prompt (parameter placeholders substituted).
    if prompts_dir:
        rp = os.path.join(prompts_dir, tid + ".txt")
        if os.path.isfile(rp):
            return open(rp, encoding="utf-8", errors="replace").read().rstrip("\n")
    p = os.path.join(tasks_dir, tid, "prompt.txt")
    if os.path.isfile(p):
        return open(p, encoding="utf-8", errors="replace").read().rstrip("\n")
    return "(no prompt text)"

class Exam:
    def __init__(self, session, tasks_dir, prompts_dir=None, state_dir=None):
        s = json.load(open(session))
        self.exam = s.get("exam", "?")
        self.start = int(s.get("start", time.time()))
        self.duration = int(s.get("duration", 9000))
        # Two-node controller sessions carry a "paper" listing every task on both
        # nodes, each tagged with the node to perform it on. Single-node sessions
        # just have "tasks". Either way self.tasks is the displayed id list.
        paper = s.get("paper")
        if paper:
            self.tasks = [p["id"] for p in paper]
            self.nodes = [p.get("node") for p in paper]
        else:
            self.tasks = s.get("tasks", [])
            self.nodes = [None] * len(self.tasks)
        self.two_node = any(self.nodes)
        self.tasks_dir = tasks_dir
        self.prompts_dir = prompts_dir
        self.state_dir = state_dir or (os.path.dirname(prompts_dir) if prompts_dir else None)
        # Practice sessions get learning aids; exam sessions stay aid-free like
        # the real exam. Practice is signalled either by a "practice-*" session
        # name (category/weak/drill) or a practice.flag dropped in the state dir
        # (rhcsa-sim practice <exam>, which keeps the real exam name for grading).
        self.practice = bool(self.state_dir and os.path.exists(os.path.join(self.state_dir, "practice.flag"))) \
            or (self.exam.startswith("practice-") and not self.exam.startswith("practice-drill"))
        self.meta = [load_meta(tasks_dir, t) for t in self.tasks]
        self.marked = [False] * len(self.tasks)
        self.check_cache = {}
        self.status = {}            # tid -> True/False from `check` (practice only)
        # Per-task time tracking (exam time management): seconds spent with each
        # task selected, persisted so `report` can show where the time went.
        self.times = {}
        self.times_path = os.path.join(self.state_dir, "tasktime.json") if self.state_dir else None
        if self.times_path and os.path.isfile(self.times_path):
            try:
                self.times = {k: float(v) for k, v in json.load(open(self.times_path)).items()}
            except Exception:
                self.times = {}

    def add_time(self, tid, secs):
        if secs <= 0:
            return
        self.times[tid] = self.times.get(tid, 0.0) + secs

    def save_times(self):
        if not self.times_path:
            return
        try:
            with open(self.times_path, "w", encoding="utf-8") as fh:
                json.dump({k: round(v, 1) for k, v in self.times.items()}, fh)
        except Exception:
            pass

    def remaining(self):
        return self.start + self.duration - int(time.time())

    def aid_text(self, kind, tid):
        """Return hint/solution text for a task (pre-rendered at practice seed)."""
        p = os.path.join(self.state_dir or "", kind, tid + ".txt")
        if self.state_dir and os.path.isfile(p):
            return open(p, encoding="utf-8", errors="replace").read().rstrip("\n")
        return (f"(no {kind[:-1]} generated for this task — run:  "
                f"rhcsa-sim {kind[:-1]} {tid})")

    def run_check(self, tid):
        """Grade ONE task via `rhcsa-sim check` and cache the result."""
        # Prefer the sibling bin of this install (works regardless of PATH).
        exe = os.path.join(os.path.dirname(self.tasks_dir.rstrip("/")), "bin", "rhcsa-sim")
        if not os.access(exe, os.X_OK):
            exe = "rhcsa-sim"
        try:
            r = subprocess.run([exe, "check", tid],
                               capture_output=True, text=True, timeout=120)
            out = ANSI_RE.sub("", (r.stdout or "") + (r.stderr or "")).strip()
        except Exception as e:  # noqa: BLE001 — show whatever went wrong
            out = f"(check failed to run: {e})"
        self.check_cache[tid] = out or "(no checker output)"
        self.status[tid] = "TASK COMPLETE" in out
        return self.check_cache[tid]

def draw(stdscr, ex):
    curses.curs_set(0)
    stdscr.nodelay(True)
    stdscr.timeout(500)
    if curses.has_colors():
        curses.start_color(); curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_CYAN, -1)    # header
        curses.init_pair(2, curses.COLOR_GREEN, -1)   # ok / time
        curses.init_pair(3, curses.COLOR_RED, -1)     # low time
        curses.init_pair(4, curses.COLOR_YELLOW, -1)  # marked
        curses.init_pair(5, curses.COLOR_BLACK, curses.COLOR_CYAN)  # selected
    sel = 0
    scroll = 0
    view = "prompt"          # prompt | hint | solution | check  (aids: practice only)
    sel_t0 = time.monotonic()  # when the current task was selected (time tracking)

    def switch_sel(new_sel):
        nonlocal sel, sel_t0, scroll, view
        ex.add_time(ex.tasks[sel], time.monotonic() - sel_t0)
        ex.save_times()
        sel = new_sel; sel_t0 = time.monotonic(); scroll = 0; view = "prompt"

    while True:
        stdscr.erase()
        h, w = stdscr.getmaxyx()
        left_w = max(28, min(40, w // 3))
        # ---- Header ----
        rem = ex.remaining()
        tstr = f"{max(0,rem)//3600:02d}:{(max(0,rem)%3600)//60:02d}:{max(0,rem)%60:02d}"
        tcol = curses.color_pair(2) if rem > 600 else curses.color_pair(3)
        if rem <= 0:
            tstr = "EXPIRED"; tcol = curses.color_pair(3)
        title = f" RHCSA EX200 SIMULATOR — exam:{ex.exam} "
        stdscr.attron(curses.color_pair(1) | curses.A_BOLD)
        stdscr.addnstr(0, 0, title.ljust(w - 14), w - 14)
        stdscr.attroff(curses.color_pair(1) | curses.A_BOLD)
        stdscr.attron(tcol | curses.A_BOLD)
        stdscr.addnstr(0, max(0, w - 13), f" ⏱ {tstr} ", 13)
        stdscr.attroff(tcol | curses.A_BOLD)
        # Pacing: minutes left per not-yet-done task (uses check results in
        # practice; in exams simply per remaining task — the same arithmetic a
        # candidate would do in their head).
        n_done = sum(1 for v in ex.status.values() if v) if ex.practice else 0
        n_left = max(1, len(ex.tasks) - n_done)
        pace = f"~{max(0, rem) / 60 / n_left:.1f}m/task · "   # leftmost: never truncated
        if ex.practice:
            done_hint = pace + ("↑↓ u/d scroll · h hint · s solution · c check · "
                                "p check ALL · m mark · q quit")
        else:
            done_hint = pace + "↑↓ select · u/d scroll · m mark · r refresh · q quit"
        stdscr.addnstr(h - 1, 0, done_hint.ljust(w - 1)[:w - 1], w - 1, curses.A_DIM)

        # ---- Left: task list ----
        for i, meta in enumerate(ex.meta):
            if i + 2 >= h - 1:
                break
            mark = "⚑" if ex.marked[i] else " "
            tag = ""
            if ex.two_node and ex.nodes[i]:
                tag = "①" if ex.nodes[i] == "node1" else "②"
            st = " "
            if ex.practice and ex.tasks[i] in ex.status:   # ✓/✗ from check (practice only)
                st = "✓" if ex.status[ex.tasks[i]] else "✗"
            label = f"{mark}{st}{i+1:>2}.{tag} {meta['TASK_TITLE']}"
            label = label[:left_w - 1].ljust(left_w - 1)
            attr = curses.A_NORMAL
            if i == sel:
                attr = curses.color_pair(5) | curses.A_BOLD
            elif ex.practice and ex.status.get(ex.tasks[i]) is True:
                attr = curses.color_pair(2)
            elif ex.practice and ex.status.get(ex.tasks[i]) is False:
                attr = curses.color_pair(3)
            elif ex.marked[i]:
                attr = curses.color_pair(4)
            stdscr.addnstr(i + 2, 0, label, left_w - 1, attr)
        # vertical divider
        for y in range(2, h - 1):
            stdscr.addch(y, left_w, curses.ACS_VLINE)

        # ---- Right: task text ----
        rx = left_w + 2
        rw = w - rx - 1
        meta = ex.meta[sel]
        vtag = "" if view == "prompt" else f"  ‹{view.upper()}›"
        # The real Exam View shows no point values or domain tags — keep exam
        # sessions faithful; practice sessions show them (useful for studying).
        ptag = f"  [{meta['TASK_DOMAIN']}, {meta['TASK_POINTS']} pts]" if ex.practice else ""
        head = f"Task {sel+1}/{len(ex.tasks)} — {meta['TASK_TITLE']}{vtag}{ptag}"
        hcol = curses.color_pair(1) if view == "prompt" else curses.color_pair(4)
        stdscr.addnstr(2, rx, head[:rw], rw, curses.A_BOLD | hcol)
        tid = ex.tasks[sel]
        if view == "hint":
            body = ex.aid_text("hints", tid)
        elif view == "solution":
            body = ex.aid_text("solutions", tid)
        elif view == "check":
            body = ex.check_cache.get(tid, "(press c to check this task)")
        else:
            body = load_prompt(ex.tasks_dir, tid, ex.prompts_dir)
        # In two-node mode, banner WHICH machine this task must be performed on.
        if view == "prompt" and ex.two_node and ex.nodes[sel]:
            node = ex.nodes[sel]
            banner = ("▶ PERFORM ON THIS MACHINE (node1)" if node == "node1"
                      else "▶ PERFORM ON node2  →  ssh student@node2.example.com, then sudo -i")
            body = banner + "\n" + ("-" * min(rw, 50)) + "\n\n" + body
        lines = []
        for para in body.split("\n"):
            if not para.strip():
                lines.append("")
            else:
                lines.extend(textwrap.wrap(para, rw) or [""])
        view_h = h - 5
        scroll = max(0, min(scroll, max(0, len(lines) - view_h)))
        for j in range(view_h):
            idx = scroll + j
            if idx >= len(lines):
                break
            stdscr.addnstr(4 + j, rx, lines[idx][:rw], rw)
        if len(lines) > view_h:
            stdscr.addnstr(h - 2, rx, f"-- {scroll+1}-{min(scroll+view_h,len(lines))}/{len(lines)} --",
                           rw, curses.A_DIM)
        stdscr.refresh()

        # ---- Input ----
        try:
            ch = stdscr.getch()
        except curses.error:
            ch = -1
        if ch in (ord('q'), ord('Q')):
            ex.add_time(ex.tasks[sel], time.monotonic() - sel_t0)
            ex.save_times()
            break
        elif ch in (curses.KEY_DOWN, ord('j')):
            switch_sel(min(len(ex.tasks) - 1, sel + 1))
        elif ch in (curses.KEY_UP, ord('k')):
            switch_sel(max(0, sel - 1))
        elif ch in (curses.KEY_NPAGE, ord('d')):
            scroll += max(1, (h - 6))
        elif ch in (curses.KEY_PPAGE, ord('u')):
            scroll -= max(1, (h - 6))
        elif ch in (ord('m'), ord('M')):
            ex.marked[sel] = not ex.marked[sel]
        elif ch in (ord('h'), ord('H')) and ex.practice:
            view = "prompt" if view == "hint" else "hint"; scroll = 0
        elif ch in (ord('s'), ord('S')) and ex.practice:
            view = "prompt" if view == "solution" else "solution"; scroll = 0
        elif ch in (ord('c'), ord('C')) and ex.practice:
            # blocking call (a few seconds) — show progress first
            stdscr.addnstr(h - 1, 0, " checking this task — please wait ... ".ljust(w - 1)[:w - 1],
                           w - 1, curses.A_BOLD)
            stdscr.refresh()
            ex.run_check(ex.tasks[sel])
            view = "check"; scroll = 0
        elif ch in (ord('p'), ord('P')) and ex.practice:
            # check EVERY task — progress shown as it goes; ✓/✗ fill the list
            for i, tid in enumerate(ex.tasks):
                msg = f" checking {i+1}/{len(ex.tasks)}: {tid} ... "
                stdscr.addnstr(h - 1, 0, msg.ljust(w - 1)[:w - 1], w - 1, curses.A_BOLD)
                stdscr.refresh()
                ex.run_check(tid)
            view = "prompt"; scroll = 0
        elif ch in (ord('r'), ord('R')):
            view = "prompt"  # loop redraws (timer + any state)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--session", required=True)
    ap.add_argument("--tasks", required=True)
    ap.add_argument("--prompts", default=None)
    ap.add_argument("--state", default=None)
    a = ap.parse_args()
    if not os.path.isfile(a.session):
        print("No active session."); return
    ex = Exam(a.session, a.tasks, a.prompts, a.state)
    curses.wrapper(draw, ex)
    rem = ex.remaining()
    print(f"Exam paper closed. Time remaining: "
          f"{max(0,rem)//3600:02d}:{(max(0,rem)%3600)//60:02d}:{max(0,rem)%60:02d}")
    print("The exam is still active. Grade with:  rhcsa-sim grade --reboot")

if __name__ == "__main__":
    main()
