# RHCSA Simulator — Practice Guide

A practical, day‑to‑day guide for practising with the simulator. For install,
architecture, and the full command reference see **README.md**.

> Run `rhcsa-sim` **inside the VM as root** (`sudo -i`). For two‑node exams run
> everything on **node1**; do `②`‑tagged tasks on node2 (`ssh student@node2.example.com`,
> then `sudo -i`). `virsh` commands run on the **host**.

## 0. One‑time setup (per VM)

```bash
sudo ./install.sh                 # deploys + (if a DVD ISO is attached) configures the offline repo
sudo rhcsa-sim local-repo         # offline DVD repo + boot‑mount service (if not auto‑configured)
# two‑node only — declare roles on each VM:
sudo rhcsa-sim node-setup --role node1 --peer <node2-ip>   # on node1
sudo rhcsa-sim node-setup --role node2 --peer <node1-ip>   # on node2
sudo rhcsa-sim doctor             # must be GREEN before you start
```

## 1. Choose how to practise

| Goal | Command |
|---|---|
| **Read a topic** (every task + worked solution) | `rhcsa-sim study <category>` |
| **Drill one topic, with aids** (~20–25 tasks) | `rhcsa-sim practice <category>` |
| **Practise your weak/never‑tried tasks** | `rhcsa-sim practice weak` |
| **Practise a whole exam, WITH aids** | `rhcsa-sim practice exam-2node-01` |
| **One quick timed task** | `rhcsa-sim drill [category]` |
| **Mastery storm** (repeat one task until 3 clean) | `rhcsa-sim master <task>` |
| **Troubleshooting gym** (fix a broken system) | `rhcsa-sim troubleshoot [category]` |
| **Mock exam** (aid‑free, counts toward readiness) | `rhcsa-sim mock` |
| **Real exam** (aid‑free) | `rhcsa-sim start exam-01` / `start exam-2node-01` |

Categories: `containers deploy filesystems network operate scripting security storage tools users`.

## 2. Open the paper (browser)

```bash
sudo rhcsa-sim tui          # opens Firefox: the "Red Hat Test Exam" view (use --text for the terminal view)
```
- **Important configuration information** — node1/node2 hostnames + IPs (read from
  *your* setup), domain/subnet, and **node1's root password** (node2's root you
  reset yourself — the first node2 task).
- **Select a VM to control** — Status / Start / Reboot / Shutdown / Hard Reboot /
  Console / Rebuild. Destructive actions on node1 ask you to type **CONFIRM**.
  A *shut‑off* peer must be powered on from your hypervisor (a guest can't do it).
- **In practice mode**, each task page has **Hint / Solution / Check**. The
  Solution shows the exact commands with your task's real values + an explanation.

## 3. Solve, then verify persistence

Do the work in a terminal. You can **reboot a VM any time to check your changes
persist** (VM panel → Reboot, or `systemctl reboot`): nothing is lost — reopen
`rhcsa-sim tui` and the paper + timer resume right where you were (the clock keeps
running in real time, like the real exam).

## 4. Grade & review

```bash
rhcsa-sim grade              # instant grade
rhcsa-sim grade --reboot     # reboot, then auto‑grade (true persistence test); report auto‑opens
rhcsa-sim report             # scored, per‑task, per‑checkpoint  (two‑node: report --combined)
rhcsa-sim review             # every failed task + its worked solution
rhcsa-sim stats              # mastery, weak areas, readiness (real exams + mock only)
```
Pass mark = **210/300**.

## 5. Reset and go again

```bash
rhcsa-sim reset              # deep clean (both nodes); KEEPS your stats/history
rhcsa-sim reset --history    # also wipe stats for a totally fresh start
```

## Notes

- **Storage practice scales with spare disks:** every storage task needs its own
  blank disk, so `practice storage` seeds **one task per spare disk**. Attach more
  spare disks to the VM for more storage tasks per round, or `reset` and re‑roll
  for a different set. (Don't use loop disks — they aren't reboot‑safe.)
- **Stats** record only real exams (`start`) and `mock` — practice/drill never
  pollute your progress.
- **`security` practice** can include `ssh-disable-root`; run it on the console or
  as the `student` user, not as root over SSH.
- **`root-password`** is done on the VM **console** via boot interruption (rd.break),
  not over SSH.

Suggested rhythm: `study` a topic → `practice` it with aids → `practice weak` →
`mock` → when you clear 210+ a few times, `start` a full exam with `grade --reboot`.
