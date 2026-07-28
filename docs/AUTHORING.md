# Task authoring spec (for contributors / agents)

Create each task as a directory `tasks/<id>/` containing these files. **Do NOT
modify any existing task or any file under `lib/`, `bin/`, `tui/`, `report/`** —
only create new task directories.

## Files
| File | Required | Purpose |
|---|---|---|
| `meta.sh` | yes | `TASK_TITLE="..."`, `TASK_DOMAIN="<domain>"`, `TASK_POINTS=<int>` |
| `prompt.txt` | yes | candidate-facing task text; may contain `{{PARAM}}` placeholders |
| `setup.sh` | yes | idempotently seed prerequisites; `echo` a one-line note; `exit 0` |
| `grade.sh` | yes | emit checkpoints via grade-lib (see below) |
| `teardown.sh` | yes | best-effort reversal; `exit 0` |
| `solution.md` | yes | reference solution (commands) |
| `params.sh` | optional | print `KEY=VALUE` lines to randomise the task per run |

`TASK_DOMAIN` ∈ `tools, scripting, operate, storage, filesystems, deploy, network, users, security, containers`.
Make `TASK_POINTS` equal the sum of the checkpoint `max` values.

## Grading contract (grade.sh)
Source the library, then emit one checkpoint per requirement:
```bash
#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "human description" <points> <assertion-fn> [args...]
ckpt_expr "human description" <points> '<shell test that returns 0/1>'
```
A task is awarded full points only if EVERY checkpoint passes (all-or-nothing),
so split a task into the checkpoints a grader would actually verify.

**Persistence matters** — grading may run after a reboot. For anything that must
survive reboot, verify BOTH runtime and config:
- service: `svc_ok <name>` (enabled AND active)
- mount: `mount_persistent <mountpoint>` (mounted AND in fstab)
- swap: check `swap_total_min` AND `fstab_has '...swap...'`

### Available assertion helpers (grade-lib.sh) — return 0 = pass
`user_exists group_exists user_in_group user_uid user_shell user_password
user_pw_maxdays path_exists is_dir file_mode file_owner file_group has_setgid
file_contains file_regex acl_has pkg_installed svc_enabled svc_active svc_ok
is_mounted fstab_has mount_persistent swap_active swap_total_min lv_exists
vg_extent_size fs_type lv_size_between selinux_enforcing fcontext_has sebool_on
firewall_port firewall_service crontab_has tuned_active tuned_recommended_profile
chrony_server image_present container_exists user_unit_enabled user_unit_active
linger_enabled default_target journal_persistent`
When no helper fits, use `ckpt_expr "desc" N '<shell test>'`.

## Parameterisation (params.sh) — optional but preferred
Print `KEY=VALUE` lines (no spaces in values). Use generators from
`$RHCSA_LIB/params.sh`: `rand_int MIN MAX`, `rand_choice a b c`, `rand_user`,
`rand_group`, `rand_password`, `rand_port`, `rand_size_mib`, `rand_profile`.
```bash
#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U_NAME=$(rand_user)"
echo "U_UID=$(rand_int 2000 6000)"
```
The KEYs become **environment variables** inside setup.sh/grade.sh/teardown.sh
(reference as `$U_NAME`), and `{{U_NAME}}` placeholders in prompt.txt are
substituted for display. Keep solution.md generic (use `<U_NAME>` etc.).

## Rules
- **Single host, offline, RHEL 9.** No internet (a local repo + chrony + loopback
  NFS already exist; container image `localhost/rhcsa-app:latest` is preloaded).
- **Self-contained:** if a task needs a user/group/file to pre-exist, its own
  setup.sh must create it. Use task-unique names (don't reuse `natasha/harry/
  sarah/sysmgrs/jacques/operator/contsvc/frank/grace/manalo` — those belong to
  existing tasks). Prefer parameterised names.
- **Idempotent setup** (safe to re-run), **safe teardown** (no destructive disk
  ops unless the task created them; storage tasks: `. "$RHCSA_LIB/storage-prep.sh"`
  then `ensure_spare_disk`/`spare_cleanup`, and assume sole use of the spare disk).
- Don't enable/start the thing you're grading in setup.sh (that's the candidate's job).

## Test-solver (REQUIRED for new tasks) — `tests/solvers/<id>.sh`
So the task can be batch-tested, also create `tests/solvers/<id>.sh`: a bash
snippet that applies the CORRECT solution. It runs with the task's params
already sourced as env vars (e.g. `$U_NAME`), as root. For storage tasks read
the spare disk via `DEV=$(cat /var/lib/rhcsa-sim/spare.dev)` and
`P="${DEV}1"; [ -b "$P" ] || P="${DEV}p1"`. It must make `grade.sh` pass fully.
Example (`tests/solvers/package-install.sh`): `dnf install -y "$PKG"`.
The solver is test-only (not installed); keep it minimal and correct.

## Worked exemplars (read these first)
- `tasks/package-install/` — parameterised (`PKG`), simple grade.
- `tasks/selinux-boolean/` — parameterised (`SBOOL`), `ckpt_expr` grade.
- `tasks/users-groups/`, `tasks/lvm-create/`, `tasks/container-service/` — richer existing examples.

## RHEL version targeting (RHCSA 9 vs 10)
The simulator serves one content set per host, chosen automatically from
`/etc/os-release`: RHEL 10 → RHCSA 10, anything else → RHCSA 9. `RHCSA_RHEL`
(9 or 10) is set in `lib/common.sh` and can be forced for testing:
`RHCSA_RHEL=10 rhcsa-sim …`.

- **Task applies to one version only:** add `TASK_RHEL="9"` (or `"10"`, or
  `"9 10"`) to `meta.sh`. **Omit it and the task applies to BOTH** — that is the
  default, so the whole legacy set needs no edit. The tag is filtered once, in
  `all_tasks()`, so every picker (practice/random/drill/weak/list) honours it.
- **Same task, different answer per version:** ship `solution.rhel10.md` (and/or
  `prompt.rhel10.txt`) beside the defaults; `lib/params.sh` prefers the
  `*.rhel<N>` file when running on that release. Only add these where the
  procedure genuinely differs.
- **Exam papers** declare their release with a header comment
  `# RHCSA_RHEL: 10` (or `9`, or `9 10`); no header = valid on both. `list`
  hides mismatched papers and `start` refuses one.
- **RHEL 10 gotchas that break ported RHEL 9 tasks:** `mkfs.xfs` refuses XFS
  below 300 MiB (size storage tasks ≥ 320 MiB); `gdisk`/`sgdisk` are gone (use
  `parted`); partitioning is GPT-only; password hashing is yescrypt (`$y$`).
- **Self-check:** `bash tests/version_test.sh` asserts detection, the
  `TASK_RHEL` filter, the versioned-file override, exam gating, category
  availability, and that no task is hidden on *both* releases (a typo'd tag).
