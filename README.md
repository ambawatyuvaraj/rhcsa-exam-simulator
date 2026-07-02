# RHCSA EX200 Exam Simulator

A self-contained simulator that reproduces the **Red Hat Certified System
Administrator (RHCSA / EX200)** exam on a RHEL 9 machine: a timed task paper,
real configuration work on a live system, automated objective grading, and a
scored, per-task report.

- **215 task templates** across all 10 RHCSA 9 objective domains. Most randomize
  their values (users, sizes, ports, paths, packages…) on every run, so exams
  can't be memorized.
- **5 single-node exams + 8 two-node exams.** A two-node exam pairs two VMs and
  grades both from one controller — like the real remote exam. Plus **category
  practice**, **mock** (aid-free rehearsal), and **drill** modes.
- **Objective grading** with a real persistence check (grade *after* a reboot),
  a scored per-task report, and per-task hints/solutions in practice mode.
- **Fully offline** — packages come from the attached RHEL install DVD.
- A faithful **browser "Test Exam" view** (paper, timer, task list, VM control)
  *and* a complete command-line interface.

> ⚠️ **Run only on a DISPOSABLE RHEL 9 (or Rocky / AlmaLinux / CentOS Stream 9)
> virtual machine.** The simulator creates users, partitions, logical volumes,
> services, and firewall/SELinux rules. **Take a VM snapshot before you start** —
> reverting it is the reliable way to reset.

## Screenshots

| Command menu | Exam paper (browser) |
|:---:|:---:|
| ![command menu](docs/screenshots/menu.png) | ![exam paper](docs/screenshots/exam-paper.png) |
| **Task detail — hint · solution · check** | **Category practice** |
| ![task detail](docs/screenshots/task-detail.png) | ![category practice](docs/screenshots/practice-category.png) |

## Install

On a disposable RHEL 9 VM with the install DVD attached:

```bash
git clone https://github.com/<user>/<repo>.git
cd <repo>
sudo ./install.sh        # installs the 'rhcsa-sim' CLI + configures the local DVD repo
```

## Usage

```bash
sudo rhcsa-sim doctor            # check the environment is ready
sudo rhcsa-sim start exam-01     # seed a 150-minute exam and start the timer
sudo rhcsa-sim tui               # open the browser exam paper (use --text for a terminal UI)
#   ... do the tasks on the live system ...
sudo rhcsa-sim grade --reboot    # grade after a reboot (persistence test), like the real exam
sudo rhcsa-sim report            # scored, per-task breakdown
sudo rhcsa-sim reset             # wipe all changes back to a clean state
```

More modes: `practice <category>` (drill one topic with hints), `mock <exam>`
(aid-free rehearsal), `list` (all exams and tasks). Two-node exams
(`exam-2node-*`) are driven from node1, which pairs and grades node2 for you.

## Requirements

- A disposable **RHEL 9 / Rocky 9 / AlmaLinux 9 / CentOS Stream 9** VM
  (~2 GB RAM, plus one blank spare disk for storage tasks).
- The matching **install DVD ISO** attached — the offline package source.
- Two-node exams need a second identical VM, paired with `rhcsa-sim node-setup`.
- The browser view needs `firefox` (optional — a terminal UI is built in).

## License

MIT — see [LICENSE](LICENSE).
