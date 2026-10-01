#!/usr/bin/env bash
# lib/common.sh — shared helpers for rhcsa-sim
# Sourced by bin/rhcsa-sim and by task scripts.

# ---- Paths -----------------------------------------------------------------
: "${RHCSA_HOME:=/opt/rhcsa-sim}"          # install root (overridable for dev)
: "${RHCSA_STATE:=/var/lib/rhcsa-sim}"     # mutable state
RHCSA_TASKS="$RHCSA_HOME/tasks"
RHCSA_EXAMS="$RHCSA_HOME/exams"
RHCSA_LIB="$RHCSA_HOME/lib"
RHCSA_ASSETS="$RHCSA_HOME/assets"
RHCSA_RESULTS="$RHCSA_STATE/results"
RHCSA_REPORTS="$RHCSA_STATE/reports"
RHCSA_SESSION="$RHCSA_STATE/session.json"

# ---- Target RHCSA version --------------------------------------------------
# The exam tracks the OS: RHEL 10 -> RHCSA 10 content, RHEL 9 -> RHCSA 9 content.
# Detected once, here, from /etc/os-release so EVERY code path (tasks, solutions,
# exams, install) sees the same answer with no user decision. Anything that is not
# RHEL 10 falls back to 9 — that covers 9.3/9.4/9.x and RHEL-likes. Override for
# authoring/testing:  RHCSA_RHEL=10 rhcsa-sim ...
: "${RHCSA_RHEL:=$( . /etc/os-release 2>/dev/null; case "${VERSION_ID%%.*}" in 10) echo 10;; *) echo 9;; esac )}"
export RHCSA_RHEL

# ---- Colours / output ------------------------------------------------------
if [[ -t 1 ]]; then
  C_RED=$'\e[31m'; C_GRN=$'\e[32m'; C_YEL=$'\e[33m'; C_BLU=$'\e[34m'
  C_BOLD=$'\e[1m'; C_DIM=$'\e[2m'; C_OFF=$'\e[0m'
else
  C_RED=; C_GRN=; C_YEL=; C_BLU=; C_BOLD=; C_DIM=; C_OFF=
fi
info()  { printf '%s[*]%s %s\n' "$C_BLU" "$C_OFF" "$*"; }
ok()    { printf '%s[+]%s %s\n' "$C_GRN" "$C_OFF" "$*"; }
warn()  { printf '%s[!]%s %s\n' "$C_YEL" "$C_OFF" "$*" >&2; }
err()   { printf '%s[x]%s %s\n' "$C_RED" "$C_OFF" "$*" >&2; }
die()   { err "$@"; exit 1; }
hr()    { printf '%s\n' "------------------------------------------------------------"; }

# ---- Guards ----------------------------------------------------------------
require_root() {
  [[ ${EUID:-$(id -u)} -eq 0 ]] || die "rhcsa-sim must be run as root (try: sudo rhcsa-sim $*)"
}

# Returns 0 if the OS is a supported RHEL 9 or 10 family release.
check_distro() {
  [[ -r /etc/os-release ]] || { warn "cannot read /etc/os-release"; return 1; }
  # shellcheck disable=SC1091
  . /etc/os-release
  local id_like="${ID_LIKE:-} ${ID:-}"
  local ver="${VERSION_ID:-0}"
  if [[ "$id_like" == *rhel* || "${ID:-}" =~ ^(rhel|rocky|almalinux|centos)$ ]]; then
    case "${ver%%.*}" in
      9|10)
        RHCSA_DISTRO="${PRETTY_NAME:-$ID $ver}"
        return 0 ;;
    esac
    warn "Detected ${PRETTY_NAME:-$ID $ver} — RHCSA targets version 9 or 10; using RHCSA $RHCSA_RHEL content."
    RHCSA_DISTRO="${PRETTY_NAME:-$ID $ver}"
    return 2
  fi
  RHCSA_DISTRO="${PRETTY_NAME:-unknown}"
  return 1
}

# Best-effort detection that we are inside a VM/container (disposable).
detect_virt() {
  local v=""
  if command -v systemd-detect-virt >/dev/null 2>&1; then
    v=$(systemd-detect-virt 2>/dev/null || true)
  fi
  RHCSA_VIRT="${v:-none}"
  [[ -n "$v" && "$v" != "none" ]]
}

# ---- Session state (tiny hand-rolled JSON, no jq/yaml dependency) ----------
# session.json schema:
# { "exam":"exam-01", "duration":9000, "start":<epoch>,
#   "tasks":["t1","t2",...] }
session_write() {
  local exam="$1" duration="$2" start="$3"; shift 3
  local tasks=("$@") j="" t
  for t in "${tasks[@]}"; do j+="\"$t\","; done
  j="${j%,}"
  mkdir -p "$RHCSA_STATE"
  cat >"$RHCSA_SESSION" <<EOF
{ "exam": "$exam", "duration": $duration, "start": $start, "tasks": [ $j ] }
EOF
}
session_field() {  # session_field <key>  (python does the parsing)
  [[ -r "$RHCSA_SESSION" ]] || return 1
  python3 - "$RHCSA_SESSION" "$1" <<'PY'
import json,sys
d=json.load(open(sys.argv[1]))
v=d.get(sys.argv[2])
if isinstance(v,list): print("\n".join(map(str,v)))
elif v is not None: print(v)
PY
}
session_active() { [[ -r "$RHCSA_SESSION" ]]; }

# ---- Task metadata ---------------------------------------------------------
# Each task dir has meta.sh defining TASK_TITLE/TASK_DOMAIN/TASK_POINTS,
# plus prompt.txt, setup.sh, grade.sh, teardown.sh, solution.md.
task_dir()   { printf '%s/%s' "$RHCSA_TASKS" "$1"; }
task_exists(){ [[ -f "$(task_dir "$1")/meta.sh" ]]; }
load_meta()  {  # load_meta <task-id> -> sets TASK_TITLE/DOMAIN/POINTS
  local d; d="$(task_dir "$1")"
  TASK_TITLE=""; TASK_DOMAIN=""; TASK_POINTS=0
  # shellcheck disable=SC1090
  . "$d/meta.sh"
}

# List all installed task ids (sorted).
# True when a task applies to the RHEL version we are running on. A task may
# declare  TASK_RHEL="10"  (or "9", or "9 10") in meta.sh; UNTAGGED MEANS EVERY
# VERSION, so the entire existing RHCSA 9 task set stays visible untouched.
task_rhel_ok() {
  # Sourced, not grepped, so it does not care how meta.sh is formatted. The
  # locals keep meta.sh's assignments inside this function (no caller pollution).
  local TASK_RHEL="" TASK_TITLE="" TASK_DOMAIN="" TASK_POINTS="" TASK_CROSSNODE=""
  # shellcheck disable=SC1090
  . "$RHCSA_TASKS/$1/meta.sh" 2>/dev/null || return 0
  [[ -z "$TASK_RHEL" ]] && return 0
  [[ " $TASK_RHEL " == *" ${RHCSA_RHEL:-9} "* ]]
}

# Every task picker (practice / random / drill / weak / list / study) enumerates
# through here, so version filtering lives in this one place.
all_tasks() {
  local t
  while read -r t; do
    task_rhel_ok "$t" && printf '%s\n' "$t"
  done < <(find "$RHCSA_TASKS" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort)
}

# Cross-node tasks (TASK_CROSSNODE=1) only belong in curated two-node exams —
# never in single-node or random composition (they need a peer + fixed roles).
is_crossnode_task() { grep -q '^TASK_CROSSNODE=1' "$(task_dir "$1")/meta.sh" 2>/dev/null; }
single_node_tasks() { local t; while read -r t; do is_crossnode_task "$t" || printf '%s\n' "$t"; done < <(all_tasks); }

# Read an exam .list file (skips blanks/comments) -> task ids on stdout.
read_exam() {
  local f="$RHCSA_EXAMS/$1.list"
  [[ -r "$f" ]] || return 1
  grep -vE '^\s*(#|$)' "$f" | awk '{print $1}'
}

# The RHEL release(s) an exam paper targets, from a "# RHCSA_RHEL: 10" header
# line in the .list file. Empty means the paper is valid on every release, so
# every existing RHCSA 9 paper keeps working with no edit.
exam_rhel() {
  local f="$RHCSA_EXAMS/$1.list"
  [[ -r "$f" ]] || f="$RHCSA_EXAMS/$1.2node.list"
  [[ -r "$f" ]] || return 1
  sed -n 's/^[[:space:]]*#[[:space:]]*RHCSA_RHEL:[[:space:]]*\([0-9 ]*\).*/\1/p' "$f" | head -1 | tr -s ' ' | sed 's/[[:space:]]*$//'
}

# True when an exam paper applies to the release we are running on.
exam_rhel_ok() {
  local v; v="$(exam_rhel "$1" 2>/dev/null)"
  [[ -z "$v" ]] && return 0
  [[ " $v " == *" ${RHCSA_RHEL:-9} "* ]]
}

# Parameterisation engine (opt-in; no effect on tasks without a params.sh).
# shellcheck source=params.sh
[[ -r "$RHCSA_LIB/params.sh" ]] && . "$RHCSA_LIB/params.sh"
# Two-node support (node1/node2). Harmless when unused.
# shellcheck source=nodes.sh
[[ -r "$RHCSA_LIB/nodes.sh" ]] && . "$RHCSA_LIB/nodes.sh"

# Tasks whose setup consumes the single spare disk (mutually exclusive in one exam).
spare_disk_tasks() {
  grep -lE 'ensure_spare_disk' "$RHCSA_TASKS"/*/setup.sh 2>/dev/null \
    | xargs -r -n1 dirname | xargs -r -n1 basename
}

# Compose a random exam: one task per domain (+ extras up to a target size),
# including AT MOST ONE spare-disk task (assigned to the storage domain), so a
# random exam never tries to use the spare disk for two tasks at once.
compose_random() {
  local target="${RHCSA_EXAM_SIZE:-16}" t d sd
  sd="$(spare_disk_tasks)"
  _is_spare() { grep -qx "$1" <<<"$sd"; }
  declare -A pick chosen grpused
  local grp
  # one task per domain (only the storage domain may contribute a spare-disk task)
  while read -r t; do
    [[ -z "$t" ]] && continue
    load_meta "$t"; d="$TASK_DOMAIN"
    [[ -n "${pick[$d]:-}" ]] && continue
    [[ "$d" != storage ]] && _is_spare "$t" && continue
    grp="$(_task_conflict_group "$t")"; [[ -n "$grp" && -n "${grpused[$grp]:-}" ]] && continue
    pick[$d]="$t"; chosen[$t]=1; [[ -n "$grp" ]] && grpused[$grp]=1
  done < <(single_node_tasks | shuf)
  local out=(); for d in "${!pick[@]}"; do out+=("${pick[$d]}"); done
  # fill extra non-spare-disk tasks up to the target exam size
  while read -r t; do
    [[ -z "$t" ]] && continue
    (( ${#out[@]} >= target )) && break
    [[ -n "${chosen[$t]:-}" ]] && continue
    _is_spare "$t" && continue
    grp="$(_task_conflict_group "$t")"; [[ -n "$grp" && -n "${grpused[$grp]:-}" ]] && continue
    out+=("$t"); chosen[$t]=1; [[ -n "$grp" ]] && grpused[$grp]=1
  done < <(single_node_tasks | shuf)
  printf '%s\n' "${out[@]}" | shuf
}

# Deterministic node assignment for a task id (stable on BOTH nodes, so a
# two-node exam splits the pool into complementary halves without coordination).
_node_of_task() {
  local h; h="$(printf '%s' "$1" | cksum | cut -d' ' -f1)"
  (( h % 2 == 0 )) && echo node1 || echo node2
}

# Compose this role's half of a random two-node exam: one task per domain from
# the role's assigned half (+ extras to target), with at most one spare-disk task.
compose_two_node() {
  local role="$1" target="${RHCSA_EXAM_SIZE:-15}" t d sd
  sd="$(spare_disk_tasks)"; _is_spare() { grep -qx "$1" <<<"$sd"; }
  declare -A pick chosen
  while read -r t; do
    [[ -z "$t" ]] && continue
    [[ "$(_node_of_task "$t")" == "$role" ]] || continue
    load_meta "$t"; d="$TASK_DOMAIN"
    [[ -n "${pick[$d]:-}" ]] && continue
    [[ "$d" != storage ]] && _is_spare "$t" && continue
    pick[$d]="$t"; chosen[$t]=1
  done < <(single_node_tasks | shuf)
  local out=(); for d in "${!pick[@]}"; do out+=("${pick[$d]}"); done
  while read -r t; do
    [[ -z "$t" ]] && continue
    (( ${#out[@]} >= target )) && break
    [[ "$(_node_of_task "$t")" == "$role" ]] || continue
    [[ -n "${chosen[$t]:-}" ]] && continue
    _is_spare "$t" && continue
    out+=("$t"); chosen[$t]=1
  done < <(single_node_tasks | shuf)
  printf '%s\n' "${out[@]}" | shuf
}

# Compose a single-CATEGORY practice set: up to <count> single-node tasks from one
# domain. Spare-disk tasks are capped to the number of available spare disks so
# every seeded task can actually claim a disk (and therefore grade correctly) —
# important for the storage category, where every task wants its own disk.
compose_domain() {
  local dom="$1" count="${2:-25}" t sd used_spare=0 rootdisk ndisk
  sd="$(spare_disk_tasks)"; _is_spare() { grep -qx "$1" <<<"$sd"; }
  # Count truly-bare spare disks exactly the way ensure_spare_disk picks them:
  # a whole disk with NO partitions/children and not mounted. This also excludes
  # the system disk even on LVM installs, where the old PKNAME-of-/ detection
  # returned empty (so the system disk was wrongly counted as a spare, letting
  # the composer seed one disk-task too many -> an occasional storage/filesystems
  # practice failure when that extra task could not get a disk).
  ndisk=0
  while read -r _d; do
    [[ -n "$_d" ]] || continue
    [[ "$(lsblk -no NAME "/dev/$_d" 2>/dev/null | wc -l)" -eq 1 ]] || continue          # has partitions/children
    [[ -z "$(lsblk -rno MOUNTPOINT "/dev/$_d" 2>/dev/null | tr -d '[:space:]')" ]] || continue  # mounted
    ((ndisk++))
  done < <(lsblk -dnro NAME,TYPE 2>/dev/null | awk '$2=="disk"{print $1}')

  # All tasks in this category.
  local cands=()
  while read -r t; do
    load_meta "$t"; [[ "$TASK_DOMAIN" == "$dom" ]] && cands+=("$t")
  done < <(single_node_tasks)
  local N=${#cands[@]}
  (( N == 0 )) && return 0

  # ROTATION: each attempt is a SUBSET (~half the category, min 6) so consecutive
  # 'practice <dom>' runs show different tasks instead of the whole category reshuffled.
  local eff="$count"
  (( eff > (N+1)/2 )) && eff=$(( (N+1)/2 ))
  (( eff < 6 ))       && eff=6
  (( eff > N ))       && eff=$N

  # History-aware order: tasks NOT in the previous attempt of this category come first
  # (each shuffled), so the next attempt leads with fresh tasks.
  local recent="${RHCSA_STATE:-/var/lib/rhcsa-sim}/.lastpractice-$dom"
  local ordered
  ordered="$( { comm -23 <(printf '%s\n' "${cands[@]}" | sort) <(sort "$recent" 2>/dev/null) | shuf
                comm -12 <(printf '%s\n' "${cands[@]}" | sort) <(sort "$recent" 2>/dev/null) | shuf; } )"

  local out=() grp; declare -A grpused
  while read -r t; do
    [[ -z "$t" ]] && continue
    grp="$(_task_conflict_group "$t")"
    [[ -n "$grp" && -n "${grpused[$grp]:-}" ]] && continue   # one task per conflict group
    if _is_spare "$t"; then (( used_spare >= ndisk )) && continue; ((used_spare++)); fi
    out+=("$t"); [[ -n "$grp" ]] && grpused[$grp]=1
    (( ${#out[@]} >= eff )) && break
  done <<< "$ordered"

  # Remember this selection so the NEXT attempt of this category leads with different tasks.
  mkdir -p "${RHCSA_STATE:-/var/lib/rhcsa-sim}" 2>/dev/null
  printf '%s\n' "${out[@]}" > "$recent" 2>/dev/null
  printf '%s\n' "${out[@]}"
}

# All RHCSA categories the practice mode accepts.
RHCSA_CATEGORIES="containers deploy filesystems network operate scripting security storage tools users"

# The categories that actually have tasks on THIS release, in the master order
# above. A whole domain can be empty on one release — containers is empty on
# RHEL 10, where the objectives dropped it — and offering an empty category
# composes a session with nothing in it. Callers validate against this, not the
# static list. Cached after the first call: it costs one meta.sh read per task.
available_categories() {
  # Cache is keyed by release: RHCSA_RHEL can change within one shell (the
  # authoring override, the test harness), and an unkeyed cache would answer
  # for the wrong release.
  if [[ "${_RHCSA_AVAIL_CATS_FOR:-}" != "${RHCSA_RHEL:-9}" ]]; then
    local t d seen=" " c out=""
    while read -r t; do
      [[ -z "$t" ]] && continue
      local TASK_TITLE="" TASK_DOMAIN="" TASK_POINTS="" TASK_CROSSNODE="" TASK_RHEL=""
      # shellcheck disable=SC1090
      . "$RHCSA_TASKS/$t/meta.sh" 2>/dev/null || continue
      d="$TASK_DOMAIN"
      [[ -n "$d" && " $seen " != *" $d "* ]] && seen="$seen$d "
    done < <(all_tasks)
    for c in $RHCSA_CATEGORIES; do
      [[ " $seen " == *" $c "* ]] && out="$out$c "
    done
    _RHCSA_AVAIL_CATS="${out% }"
    _RHCSA_AVAIL_CATS_FOR="${RHCSA_RHEL:-9}"
  fi
  printf '%s' "$_RHCSA_AVAIL_CATS"
}

# True when a category has tasks on this release.
category_available() { [[ " $(available_categories) " == *" $1 "* ]]; }

# Mutually-exclusive task groups: tasks that share a FIXED resource (an output
# file, the default boot target, one system service, the tuned profile, the
# %sysmgrs sudoers/group) and would clobber each other if seeded together. The
# category-practice composer picks AT MOST ONE task from each group so every
# seeded task grades correctly. (Full exams pick ~2/domain, so they rarely
# co-occur; this matters mainly for dense single-topic practice.)
RHCSA_CONFLICT_GROUPS=(
  "grep-string head-tail-range script-while-read"                                    # share /root/lines.txt
  "boot-target default-target-graphical"                                             # opposite default target
  "service-enable service-disable service-restart service-mask enable-service-boot"  # same atd/rsyncd service
  "tuning-profile tuned-specific"                                                     # the one active tuned profile
  "sudo-nopasswd sudo-group-passwd sudo-defaults"                                     # %sysmgrs sudoers rule
  "collaborative-dir users-groups"                                                    # the sysmgrs group definition
  "journal-vacuum journal-grep journal-find journal-priority"                         # vacuum deletes entries the reads need
  "selinux-mode selinux-permissive selinux-disabled"                                  # opposite global SELinux state
  "scp-pull secure-copy rsync-dir"                                                    # copy into overlapping /root targets
  "f08-lvcreate f08-lvresize"                                                          # both define VG 'wgroup' (exam splits them across nodes)
  "lvm-create e2-lvm"                                                                  # both CREATE VG 'myvg' / LV 'mylv' at /mnt/mydata
  "lvm-resize e2-lvresize"                                                             # both seed an LV 'vo' at /mnt/vo (would clobber the mount)
)
_task_conflict_group() {
  local t="$1" g
  for g in "${RHCSA_CONFLICT_GROUPS[@]}"; do [[ " $g " == *" $t "* ]] && { printf '%s' "$g"; return; }; done
}

# ---- Offline package source (real-exam style: a local install-DVD repo) -----
# The real RHCSA exam has NO internet — packages come from a local repository.
# This detects an attached RHEL/Rocky/Alma/CentOS Stream 9 DVD ISO and configures
# it as a dnf repo so package tasks work fully offline. Idempotent.
setup_local_repo() {
  local mp=/mnt/dvd dev="" d
  if mountpoint -q "$mp" 2>/dev/null && [[ -d "$mp/BaseOS" ]]; then
    dev="$(findmnt -no SOURCE "$mp" 2>/dev/null)"
  else
    mkdir -p "$mp"
    # Probe likely DVD devices + anything formatted iso9660.
    for d in /dev/sr0 /dev/sr1 /dev/cdrom $(lsblk -rno NAME,FSTYPE 2>/dev/null | awk '$2=="iso9660"{print "/dev/"$1}'); do
      [[ -b "$d" ]] || continue
      mount -o ro "$d" "$mp" 2>/dev/null || continue
      [[ -d "$mp/BaseOS" ]] && { dev="$d"; break; }
      umount "$mp" 2>/dev/null
    done
  fi
  if [[ ! -d "$mp/BaseOS" ]]; then
    warn "No install media found. Attach your RHEL/Rocky/Alma/CentOS 9 DVD ISO to the VM"
    warn "  (virt-manager: Add Hardware > Storage > Device CDROM > your .iso), then re-run 'rhcsa-sim local-repo'."
    return 1
  fi
  # Persist the mount across reboot (nofail so boot never hangs without media).
  [[ -n "$dev" ]] && ! grep -q "[[:space:]]$mp[[:space:]]" /etc/fstab 2>/dev/null && \
    echo "$dev $mp iso9660 ro,nofail 0 0" >> /etc/fstab
  # Re-mount the DVD at EVERY boot via a tiny service. fstab 'nofail' can silently
  # skip the mount on a cold boot when the virtual CD-ROM is not ready in time,
  # leaving the offline repo gone after a reboot (the repo FILE persists, only the
  # mount is lost). This service waits for the device then mounts it, so package
  # tasks + 'doctor' keep working after the reboots students do to test persistence.
  cat >/etc/systemd/system/rhcsa-localrepo.service <<'UNIT'
[Unit]
Description=RHCSA simulator: mount the offline DVD repo at boot
After=local-fs.target
ConditionPathExists=/etc/yum.repos.d/rhcsa-dvd.repo
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c 'for i in $(seq 1 20); do [ -b /dev/sr0 ] && blkid /dev/sr0 >/dev/null 2>&1 && break; sleep 2; done; mountpoint -q /mnt/dvd || mount /mnt/dvd 2>/dev/null || mount -o ro /dev/sr0 /mnt/dvd 2>/dev/null; true'
[Install]
WantedBy=multi-user.target
UNIT
  systemctl daemon-reload 2>/dev/null
  systemctl enable rhcsa-localrepo.service >/dev/null 2>&1
  # Build the repo file (BaseOS + AppStream, + CRB/optional if present).
  { echo "[dvd-baseos]";    echo "name=Local DVD - BaseOS";    echo "baseurl=file://$mp/BaseOS";    echo "enabled=1"; echo "gpgcheck=0"
    echo "[dvd-appstream]"; echo "name=Local DVD - AppStream"; echo "baseurl=file://$mp/AppStream"; echo "enabled=1"; echo "gpgcheck=0"
    for x in CRB crb plus AppStream/debug; do [[ -d "$mp/$x" && "$x" != AppStream/debug ]] && { echo "[dvd-$x]"; echo "name=Local DVD - $x"; echo "baseurl=file://$mp/$x"; echo "enabled=1"; echo "gpgcheck=0"; }; done
  } > /etc/yum.repos.d/rhcsa-dvd.repo
  # Make unreachable repos NON-FATAL so an offline machine whose default network
  # repos can't be reached still installs from the DVD (otherwise the whole `dnf`
  # transaction errors out). Non-destructive: networked users keep their repos.
  grep -qs '^[[:space:]]*skip_if_unavailable' /etc/dnf/dnf.conf 2>/dev/null || \
    printf 'skip_if_unavailable=True\n' >> /etc/dnf/dnf.conf
  dnf clean all >/dev/null 2>&1
  if dnf -q makecache >/dev/null 2>&1; then
    ok "Local DVD repo configured at $mp — offline package installs work (like the real exam)."
    echo "  Active repos: $(dnf -q repolist 2>/dev/null | grep -i dvd | awk '{print $1}' | tr '\n' ' ')"
    # install.sh's dependency install ran BEFORE this repo existed (a no-op when
    # offline), so install the core packages tasks ASSUME are present now that a
    # working repo exists. NOT the graded package-install/package-group targets
    # (tree/tcpdump/cockpit/make/…) — those stay for the candidate to install.
    info "Installing core task packages from the local repo ..."
    dnf -y install podman nfs-utils autofs chrony httpd tuned acl lvm2 at rsync-daemon createrepo_c xorriso quota firefox xdg-utils >/dev/null 2>&1 || true
    ok "Core task packages ready (podman, nfs-utils, autofs, httpd, …)."
    return 0
  fi
  warn "DVD mounted but dnf makecache failed — check the ISO has BaseOS/AppStream."
  return 1
}

# Make sure the local DVD repo is actually mounted (it can get unmounted by a
# reboot or a stray umount). Called before every exam seed so package tasks never
# silently fail offline. No-op if the DVD repo isn't configured.
_ensure_local_repo_mounted() {
  # Self-heal: if the DVD repo file is gone (e.g. a prior reset dropped it while
  # the disc was unmounted) but a RHEL DVD is still attached, recreate everything.
  if [ ! -f /etc/yum.repos.d/rhcsa-dvd.repo ]; then
    local sd
    for sd in /dev/sr0 /dev/sr1 /dev/cdrom; do
      [ -b "$sd" ] && blkid "$sd" 2>/dev/null | grep -qiE 'iso9660|BaseOS' && { setup_local_repo >/dev/null 2>&1; break; }
    done
    [ -f /etc/yum.repos.d/rhcsa-dvd.repo ] || return 0
  fi
  if ! { mountpoint -q /mnt/dvd 2>/dev/null && [ -f /mnt/dvd/BaseOS/repodata/repomd.xml ]; }; then
    mkdir -p /mnt/dvd
    local d ok=
    for d in /dev/sr0 /dev/sr1 /dev/cdrom; do
      [ -b "$d" ] || continue
      mount -o ro "$d" /mnt/dvd 2>/dev/null && [ -d /mnt/dvd/BaseOS ] && { ok=1; break; }
      umount /mnt/dvd 2>/dev/null
    done
    [ -n "$ok" ] || { warn "local DVD repo configured but the disc isn't mounted and couldn't be remounted — package tasks may fail. Re-run 'rhcsa-sim local-repo'."; return 1; }
  fi
  # PRE-WARM the dnf cache: the FIRST `dnf install` during seeding (e.g. podman
  # on the headless node) would otherwise rebuild a cold cache (reset runs
  # `dnf clean all`) and hit the 20s fail-fast timeout → the package silently
  # doesn't install and that task fails. makecache off a local DVD is quick.
  dnf -q makecache >/dev/null 2>&1 || true
  return 0
}

# ---- Deep reset: undo everything a practice session changed -----------------
# Cleans storage (partitions/LVM/swap/mounts/fstab), network (dummy NICs + NM
# connections), and task-created files — restoring the VM to a clean practice
# state. KEEPS the infrastructure: the spare disks themselves (as bare hardware),
# the DVD repo at /mnt/dvd, node.conf / rhcsactl / the root SSH key. Never
# touches the root disk or root VG.

# Disks the OS install itself lives on: whatever holds /, /boot, /boot/efi, plus
# EVERY PV of the OS volume group. Independent of what else is mounted or swapped
# on, so it is safe to call at any time (doctor, before swapoff, mid-session).
# The PV walk matters: an installer given two disks can put the OS VG on both
# (e.g. sda3 + sdb1), and a disk holding only the OS swap LV looks unused once
# swap is off — it must never be mistaken for a spare.
_os_disks() {
  local rootsrc rootvg
  rootsrc="$(findmnt -no SOURCE / 2>/dev/null)"
  rootvg="$(lvs --noheadings -o vg_name "$rootsrc" 2>/dev/null | tr -d ' ')"
  { printf '%s\n' "$rootsrc"
    findmnt -no SOURCE /boot 2>/dev/null
    findmnt -no SOURCE /boot/efi 2>/dev/null
    [ -n "$rootvg" ] && pvs --noheadings -o pv_name -S vg_name="$rootvg" 2>/dev/null
  } | while read -r src; do
        [ -n "$src" ] || continue
        lsblk -rsno NAME,TYPE "$src" 2>/dev/null | awk '$2=="disk"{print $1}'
      done | sort -u
}

# Physical disk(s) under a block device (LV, LUKS mapping, partition, ...), one per line.
_disks_of() { lsblk -rsno NAME,TYPE "$1" 2>/dev/null | awk '$2=="disk"{print $1}'; }

# Physical disk(s) the OS lives on — reset NEVER wipes these. Disk-name-agnostic
# (vd*/sd*/nvme*/hd*) and LVM/RAID-aware: walks each mounted device / active swap /
# the root source DOWN to its physical disk via lsblk's reverse dependency tree.
# Returns bare disk names (e.g. "vda", "sda", "nvme0n1"). Call AFTER sim mounts +
# extra swap are turned off, so only the real system disk(s) remain.
_system_disks() {
  { _os_disks | sed 's|^|/dev/|'
    findmnt -no SOURCE / 2>/dev/null
    lsblk -rno NAME,MOUNTPOINT 2>/dev/null | awk '$2!=""{print "/dev/"$1}'
    swapon --show=NAME --noheadings 2>/dev/null
  } | while read -r src; do
        [ -n "$src" ] || continue
        lsblk -rsno NAME,TYPE "$src" 2>/dev/null | awk '$2=="disk"{print $1}'
      done | sort -u
}

_deep_reset_local() {
  local rootsrc rootdisk m d p vg nic c u _rootvg _dmesc _sysswap_ids
  rootsrc="$(findmnt -no SOURCE / 2>/dev/null)"
  rootdisk="$(lsblk -no PKNAME "$rootsrc" 2>/dev/null | head -1)"

  # Name of the VG that holds the OS, and its device-mapper form. LVM doubles a
  # '-' in a VG name in the dm name ('rhel_host-016' -> 'rhel_host--016-root'),
  # so the dm guards below MUST match on the ESCAPED form — otherwise the live
  # root/swap LVs look like foreign orphans and get removed. Default to 'rhel'
  # for a non-LVM root (there is no root VG to protect then).
  _rootvg="$(lvs --noheadings -o vg_name "$rootsrc" 2>/dev/null | tr -d ' ')"
  [ -z "$_rootvg" ] && _rootvg=rhel
  _dmesc="${_rootvg//-/--}"

  # Capture the machine's REAL swap identity (path + UUID + LABEL) BEFORE
  # swapoff, so the fstab cleanup below keeps its swap line no matter which VG
  # it lives in or whether fstab references it by UUID/LABEL. Only swap on an OS
  # disk counts: a candidate's swap on a spare disk is still active here when its
  # teardown didn't run, and keeping its line would leave fstab pointing at a
  # device the wipe below destroys.
  local _osdisks; _osdisks="$(_os_disks)"
  _sysswap_ids="$(swapon --show=NAME --noheadings 2>/dev/null | while read -r _s; do
      lsblk -rsno NAME,TYPE "$_s" 2>/dev/null | awk '$2=="disk"{print $1}' | grep -qxF "$_osdisks" || continue
      printf '%s\n' "$_s"
      blkid -s UUID  -o value "$_s" 2>/dev/null
      blkid -s LABEL -o value "$_s" 2>/dev/null
    done | tr '\n' ' ')"

  # --- storage: unmount sim mountpoints (NEVER /mnt/dvd), disable extra swap ---
  for m in $(findmnt -rn -o TARGET 2>/dev/null | grep -E '^/(mnt|autohomes|rhome|shared-tmp|team|restricted|webdata|exports|data)' | grep -vx /mnt/dvd); do
    umount -lf "$m" 2>/dev/null
  done
  umount -lf /autohomes/* /rhome/* 2>/dev/null
  timeout 15 systemctl stop autofs nfs-server 2>/dev/null
  swapoff -a 2>/dev/null
  # Identify the OS disk(s) — NEVER wiped. Computed AFTER unmount + swapoff above,
  # so only the real system disk(s) still carry a mount/swap.
  local sysdisks; sysdisks="$(_system_disks)"
  if [ -z "$sysdisks" ]; then
    # FAILSAFE: never risk the system disk if we cannot positively identify it.
    echo "  reset: could not identify the system disk — leaving spare disks untouched for safety." >&2
  else
    # remove any VG that lives entirely on spare (non-system) disks — never the root VG
    for vg in $(vgs --noheadings -o vg_name 2>/dev/null | tr -d ' '); do
      local _onsys=0 _pv _pvd
      for _pv in $(pvs --noheadings -o pv_name,vg_name 2>/dev/null | awk -v v="$vg" '$2==v{print $1}'); do
        _pvd="$(lsblk -rsno NAME,TYPE "$_pv" 2>/dev/null | awk '$2=="disk"{print $1}' | head -1)"
        grep -qx "$_pvd" <<<"$sysdisks" && _onsys=1
      done
      [ "$_onsys" = 0 ] && { vgchange -an "$vg" 2>/dev/null; vgremove -f "$vg" 2>/dev/null; }
    done
    # Force down any device-mapper volume that is NOT part of the system (root) VG,
    # including LVM ORPHANS whose VG metadata was already overwritten — e.g. a task
    # disk holding a whole-disk PV got repartitioned, so its LV (wgroup-wlogic) is
    # invisible to `vgs` yet still active+mounted. The VG loop above can't reach
    # such a mapping; left alone it pins its disk open, the wipe below can't fully
    # clear the disk, and the stale volume reappears at the next seed mounted with
    # NO backing VG ("Volume group wgroup not found"). dmsetup removes it by its
    # live mapping. Three passes resolve snapshot origin/cow ordering.
    local _dm _pass _rm
    for _pass in 1 2 3; do
      _rm=0
      for _dm in $(dmsetup ls 2>/dev/null | awk 'NF{print $1}'); do
        case "$_dm" in "${_dmesc}-"*) continue ;; esac   # system root/swap LVs — never touch
        # ...nor anything else stacked on an OS disk: a LUKS root (luks-<uuid>), a
        # second system VG (/home), etc. — their names don't carry the root VG's.
        _disks_of "/dev/mapper/$_dm" | grep -qxF "$sysdisks" && continue
        umount -lf "/dev/mapper/$_dm" 2>/dev/null
        dmsetup remove -f "$_dm" >/dev/null 2>&1 && _rm=1
      done
      [ "$_rm" = 0 ] && break
    done
    # Wipe EVERY non-system whole disk back to bare hardware, regardless of naming
    # (vd*/sd*/nvme*/hd*) — so reset works on KVM, VMware/VirtualBox and NVMe alike.
    # (pvremove prints "Labels … wiped" only for PV-bearing disks; the rest are
    # wiped silently by wipefs — hence the explicit summary line.)
    local _wiped=""
    for d in $(lsblk -dnro NAME,TYPE 2>/dev/null | awk '$2=="disk"{print $1}'); do
      case "$d" in sr*|loop*|fd*) continue;; esac        # CD-ROM / loop / floppy — not spare disks
      grep -qx "$d" <<<"$sysdisks" && continue            # OS disk — never touch
      local _dev="/dev/$d"
      for p in "$_dev"*[0-9]; do [ -b "$p" ] && wipefs -afq "$p" 2>/dev/null; done
      pvremove -ff -y "$_dev"* 2>/dev/null; wipefs -afq "$_dev" 2>/dev/null
      # Zero the first 64 MiB: wipefs/pvremove clear labels but NOT the old XFS/ext4
      # superblock living inside former LV extents (~1 MiB in). A fresh vgcreate then
      # lvcreate allocates from PE 0 and hits that stale signature, so non-interactive
      # `lvcreate`/`mkfs` abort on the [y/n] prompt. Zeroing the head leaves a truly
      # bare disk (like a fresh exam VM) — instant (~0.1s), spare disks only. (blkdiscard
      # is unreliable here: qcow2 discard returns success but doesn't zero the bytes.)
      dd if=/dev/zero of="$_dev" bs=1M count=64 conv=fsync status=none 2>/dev/null
      timeout 8 partprobe "$_dev" 2>/dev/null
      _wiped="$_wiped $d"
    done
    [ -n "$_wiped" ] && echo "  spare disks reset to bare:$_wiped"
  fi
  losetup -D 2>/dev/null
  # fstab: drop sim-added lines; keep root + the original root swap
  sed -i -E '\#(/mnt/[^d]|/mnt/dvd|/autohomes|/rhome|/swapfile|^tmpfs|[[:space:]]tmpfs[[:space:]]|LABEL=|UUID=[0-9a-f-]+[[:space:]]+/mnt|/dev/[vsh]d[b-z]|/dev/nvme[0-9]|/exports/)#{/\/mnt\/dvd/!d}' /etc/fstab 2>/dev/null
  # Keep the machine's own swap line(s) — matched by the system swap device
  # path / UUID / LABEL captured above, or by the OS VG name (plain + escaped).
  # A hardcoded 'rhel-swap' dropped the swap line on any other VG name (e.g.
  # 'rhel_host-016'), silently disabling swap persistence after a reset.
  if [ -f /etc/fstab ]; then
    awk -v keep="${_sysswap_ids} ${_rootvg} ${_dmesc}" '
      {
        if ($0 ~ /(^|[[:space:]])swap([[:space:]]|$)/) {
          n = split(keep, k, " "); ok = 0
          for (i = 1; i <= n; i++) if (k[i] != "" && index($0, k[i])) ok = 1
          if (!ok) next
        }
        print
      }' /etc/fstab > /etc/fstab.rhcsa.tmp 2>/dev/null && cat /etc/fstab.rhcsa.tmp > /etc/fstab 2>/dev/null
    rm -f /etc/fstab.rhcsa.tmp
  fi
  find /mnt -maxdepth 1 -mindepth 1 ! -name dvd -exec rm -rf {} + 2>/dev/null
  rm -rf /swapfile /autohomes /rhome /exports 2>/dev/null

  # --- network: remove the simulator's dedicated test NICs + NM connections ---
  for c in $(nmcli -t -f NAME con show 2>/dev/null | grep -E '^rhcsa|^peerrepo'); do nmcli con delete "$c" 2>/dev/null; done
  for u in rhcsa-dummy rhcsa-fwnic rhcsa6-nic; do systemctl disable --now "$u.service" 2>/dev/null; rm -f "/etc/systemd/system/$u.service"; done
  for nic in $(ip -o link show type dummy 2>/dev/null | awk -F': ' '{print $2}' | grep -E '^rhcsa'); do ip link del "$nic" 2>/dev/null; done
  systemctl daemon-reload 2>/dev/null

  # --- accounts: remove every human USER/GROUP the practice created (UID/GID
  #     >= 1000), along with its home, mail spool and crontab. Preserve the
  #     simulator service account 'rhcsactl', the documented 'student' practice
  #     login, the account that invoked sudo (the human running the exam — NOT
  #     necessarily named 'student', e.g. 'lollo'), and every member of the admin
  #     group 'wheel'. Tasks never add users to 'wheel' (only restrict-su toggles
  #     PAM), so nothing a task creates is protected. Names are captured by the
  #     command substitution BEFORE the loop body runs, so deleting while reading
  #     /etc/passwd is safe. -----------------------------------------------------
  local acct _keep=" student rhcsactl " _keepg=" student rhcsactl wheel "
  [[ -n "${SUDO_USER:-}" ]] && _keep="$_keep$SUDO_USER "
  for acct in $(getent group wheel 2>/dev/null | awk -F: '{print $4}' | tr ',' ' '); do
    _keep="$_keep$acct "
  done
  for acct in $_keep; do
    local _pg; _pg="$(id -gn "$acct" 2>/dev/null)" || true
    [[ -n "$_pg" ]] && _keepg="$_keepg$_pg "
  done
  for acct in $(awk -F: '$3>=1000 && $3<60000 {print $1}' /etc/passwd 2>/dev/null); do
    case "$_keep" in *" $acct "*) continue;; esac
    pkill -9 -u "$acct" 2>/dev/null
    crontab -r -u "$acct" 2>/dev/null
    userdel -rf "$acct" 2>/dev/null
  done
  for acct in $(awk -F: '$3>=1000 && $3<60000 {print $1}' /etc/group 2>/dev/null); do
    case "$_keepg" in *" $acct "*) continue;; esac
    groupdel "$acct" 2>/dev/null
  done
  # sweep orphaned crontabs / home dirs whose owner no longer exists
  for acct in /var/spool/cron/*; do [ -e "$acct" ] && { id "$(basename "$acct")" >/dev/null 2>&1 || rm -f "$acct"; }; done
  for acct in /home/*; do [ -d "$acct" ] && { id "$(basename "$acct")" >/dev/null 2>&1 || rm -rf "$acct"; }; done

  # --- NFS exports + sim sysctl drop-ins ------------------------------------
  if [ -f /etc/exports ]; then sed -i '\#/exports/#d' /etc/exports 2>/dev/null; exportfs -ra 2>/dev/null; fi
  rm -f /etc/exports.d/rhcsa*.exports 2>/dev/null
  rm -f /etc/sysctl.d/99-rhcsa.conf /etc/sysctl.d/99-ipforward.conf 2>/dev/null
  sysctl --system >/dev/null 2>&1 || true

  # --- SELinux: reset ALL local customizations to defaults — on a practice VM
  #     every local change is a task artifact (login maps, booleans, ports, file
  #     contexts). login -D also clears mappings that referenced removed users. --
  if command -v semanage >/dev/null 2>&1; then
    semanage login -D    2>/dev/null
    semanage boolean -D  2>/dev/null
    semanage port -D     2>/dev/null
    semanage fcontext -D 2>/dev/null
    restorecon -RF /srv /var/www 2>/dev/null
  fi
  # SELinux mode: restore Enforcing (RHCSA default). A selinux-mode/permissive
  # task may have left it permissive/disabled — which would mask real failures
  # in the next exam (and `doctor` requires Enforcing).
  setenforce 1 2>/dev/null
  [ -f /etc/selinux/config ] && sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config 2>/dev/null

  # --- httpd: restore the default 'Listen 80' (the selinux-port task leaves it
  #     on 82, which breaks repo-server and any other http task), and drop sim
  #     systemd service overrides (e.g. a bad Restart= drop-in). Restart httpd if
  #     it's running so the port change takes effect. -----------------------------
  if [ -f /etc/httpd/conf/httpd.conf ]; then
    sed -i '/^Listen /d' /etc/httpd/conf/httpd.conf 2>/dev/null
    grep -qxE 'Listen 80' /etc/httpd/conf/httpd.conf 2>/dev/null || echo 'Listen 80' >> /etc/httpd/conf/httpd.conf
  fi
  rm -f /etc/systemd/system/*.service.d/override.conf 2>/dev/null
  systemctl daemon-reload 2>/dev/null
  systemctl try-restart httpd 2>/dev/null

  # --- firewall: drop sim-added ports + non-base services, but KEEP ssh and the
  #     base zone services so a reset can never lock you out. --------------------
  if command -v firewall-cmd >/dev/null 2>&1; then
    for p in $(firewall-cmd --permanent --list-ports 2>/dev/null); do firewall-cmd --permanent --remove-port="$p" >/dev/null 2>&1; done
    for c in $(firewall-cmd --permanent --list-services 2>/dev/null); do
      case " ssh dhcpv6-client mdns samba-client cockpit " in *" $c "*) continue;; esac
      firewall-cmd --permanent --remove-service="$c" >/dev/null 2>&1
    done
    firewall-cmd --reload >/dev/null 2>&1
  fi

  # --- SSH: undo ONLY the simulator's own sshd drop-ins (ssh-port /
  #     ssh-disable-root) and RELOAD. Never touch authorized_keys, never stop or
  #     restart sshd (a failed restart would lock you out) — reload is safe. -----
  rm -f /etc/ssh/sshd_config.d/99-rhcsa-*.conf 2>/dev/null
  systemctl reload sshd 2>/dev/null || true

  # --- network services + shared configs created by server/cross-node tasks:
  #     reset to baseline so a fresh exam never finds a completed task's leftovers
  #     (leftovers would make re-seeded tasks grade as already-done). Per-task
  #     teardowns also do this, but only for the active session — this backstops
  #     ALL of them (sim-only artifacts on these disposable practice VMs). --------
  # NFS exports (nfs-export / autofs-* / nfs-mount* tasks) — re-created at next seed:
  rm -f /etc/exports.d/*.exports 2>/dev/null
  sed -i '\#/exports#d' /etc/exports 2>/dev/null
  exportfs -ra >/dev/null 2>&1
  systemctl disable --now nfs-server >/dev/null 2>&1
  # HTTP package repo (repo-server task) — re-created at next seed:
  systemctl disable --now httpd >/dev/null 2>&1
  rm -rf /var/www/html/pkgrepo 2>/dev/null
  # chrony sim lines (ntp-server allow/local; any task-added 'server' line — RHEL's
  #  default uses 'pool', so dropping 'server' lines only removes sim entries):
  if [ -f /etc/chrony.conf ]; then
    sed -i '/^[[:space:]]*server[[:space:]]/d; /^[[:space:]]*allow[[:space:]]/d; /^[[:space:]]*local stratum/d' /etc/chrony.conf 2>/dev/null
    systemctl try-restart chronyd >/dev/null 2>&1
  fi
  # SSH keypair from ssh-key-peer (the controller channel uses rhcsactl's key, not root's):
  rm -f /root/.ssh/id_ed25519 /root/.ssh/id_ed25519.pub 2>/dev/null
  # locale.conf MUST stay world-readable (login reads it via /etc/profile.d/lang.sh); a
  # stray 600 (e.g. a backup copied under a tight umask, then restored) breaks every new
  # shell with "sed: can't read /etc/locale.conf". Drop any stale backup + force 644.
  rm -f /etc/locale.conf.rhcsabak 2>/dev/null
  [ -e /etc/locale.conf ] && chmod 0644 /etc/locale.conf 2>/dev/null

  # --- root password: restore the documented practice default. The root-password
  #     exam task scrambles it (real-exam style); its teardown restores it, but a
  #     session abandoned WITHOUT reset (or pre-fix drift) could leave it unknown.
  #     The baseline for these disposable practice VMs is root/password. ---------
  echo "root:password" | chpasswd 2>/dev/null || true

  # --- sudoers: fix perms so `visudo -c` never fails (one stale 0644 drop-in
  #     breaks EVERY sudo task's validity check), and drop sim sudo drop-ins —
  #     keep the infra (rhcsactl) and base (wheel / README / numbered) files. ---
  if [ -d /etc/sudoers.d ]; then
    chmod 0440 /etc/sudoers.d/* 2>/dev/null
    for c in /etc/sudoers.d/*; do
      [ -e "$c" ] || continue
      case "$(basename "$c")" in rhcsactl|wheel|README|[0-9]*) continue;; esac
      rm -f "$c"
    done
  fi

  # --- services: unmask anything a service-mask task left masked (symlink to
  #     /dev/null), so a later service task can enable it again. On a practice VM
  #     all masks are sim-created. -----------------------------------------------
  for u in /etc/systemd/system/*.service; do
    [ "$(readlink "$u" 2>/dev/null)" = /dev/null ] && systemctl unmask "$(basename "$u")" 2>/dev/null
  done

  # --- drop dangling file:// repos: a .repo whose baseurl path no longer exists
  #     makes EVERY `dnf` command fail (so all later package tasks break). Keep
  #     the DVD repo (its path exists). -----------------------------------------
  for c in /etc/yum.repos.d/*.repo; do
    [ -e "$c" ] || continue
    # NEVER drop the offline DVD repo — if /mnt/dvd is just unmounted its path
    # looks "missing"; _ensure_local_repo_mounted (below) remounts/recreates it.
    [ "$c" = /etc/yum.repos.d/rhcsa-dvd.repo ] && continue
    while IFS= read -r p; do
      [ -z "$p" ] && continue
      [ -d "$p" ] || { rm -f "$c"; break; }
    done < <(grep -hoE 'file://[^ ]+' "$c" 2>/dev/null | sed 's|file://||; s|/repodata.*||')
  done
  dnf clean all >/dev/null 2>&1

  # --- keep the local DVD repo available (the disc must stay mounted) ----------
  _ensure_local_repo_mounted 2>/dev/null || true

  # --- podman: remove all root containers so container tasks start clean next
  #     session (stale containers with the same names cause flaky failures).
  #     Keep images — task setups reload them idempotently. ---------------------
  command -v podman >/dev/null 2>&1 && podman rm -af >/dev/null 2>&1

  # --- files / services created by tasks (best-effort, common locations) ------
  # Remove EVERY task-created dir under /opt (container bind dirs like
  # files/processed/progress, find/copy sources like datasrc/sizesrc/dest/sdata,
  # etc.) but KEEP the simulator install + the local repo. Task setups recreate
  # whatever the current exam needs, so this stops one exam's /opt dirs (and their
  # walhalla/wallah ownership) from leaking into the next.
  for _d in /opt/*; do
    case "$_d" in
      /opt/rhcsa-repo|/opt/rhcsa-sim|/opt/rhcsa-simulator) : ;;
      *) rm -rf "$_d" 2>/dev/null ;;
    esac
  done
  # Exam container users own those bind dirs; remove them (their teardowns do too,
  # but only when the task is tracked). NEVER touch the login/controller accounts.
  for _u in walhalla wallah contsvc; do
    id "$_u" >/dev/null 2>&1 || continue
    loginctl disable-linger "$_u" >/dev/null 2>&1
    pkill -9 -u "$_u" 2>/dev/null; sleep 0.2
    userdel -rf "$_u" >/dev/null 2>&1
  done
  rm -rf /var/www/html/pkgrepo /usr/share/rhcsa 2>/dev/null
  rm -f /opt/sedsrc.txt /opt/grepsrc* 2>/dev/null
  pkill -9 -f 'cpuhog -c' 2>/dev/null; pkill -9 -f memhog 2>/dev/null
  rm -f "$RHCSA_STATE"/claims/*.dev "$RHCSA_STATE"/cpuhog.pid "$RHCSA_STATE"/swap.base 2>/dev/null
  swapon -a 2>/dev/null

  # --- clear stale 'failed' unit records so the box returns to 'running', not
  #     'degraded': not-found ghost .mount units (from old storage tasks),
  #     user@UID.service of deleted users, and any service a prior task left
  #     in a failed state. reset-failed only clears records; it starts nothing.
  systemctl reset-failed >/dev/null 2>&1
  return 0
}

# ---- Weak-area practice (uses the persistent attempt history) ---------------
# Priority order: tasks whose LATEST attempt failed (most recent failure first),
# then never-attempted tasks (shuffled), then the stalest passes. Single-node
# tasks only; same conflict-group + spare-disk caps as compose_domain.
_weak_candidates() {    # _weak_candidates <history-file>  -> ordered ids on stdout
  local hist="$1"
  { single_node_tasks; echo "---HIST---"; cat "$hist" 2>/dev/null; } | python3 -c '
import json,random,sys
lines=sys.stdin.read().splitlines()
i=lines.index("---HIST---")
tasks=[t for t in lines[:i] if t]
latest={}
for ln in lines[i+1:]:
    try: d=json.loads(ln)
    except Exception: continue
    if d.get("kind")!="task" or not d.get("task"): continue
    latest[d["task"]]=(d.get("ts",0), bool(d.get("pass")))
failed=sorted(((ts,t) for t,(ts,ok) in latest.items() if not ok and t in tasks), reverse=True)
never=[t for t in tasks if t not in latest]; random.shuffle(never)
passed=sorted((ts,t) for t,(ts,ok) in latest.items() if ok and t in tasks)
for _,t in failed: print(t)
for t in never: print(t)
for _,t in passed: print(t)
'
}
compose_weak() {        # compose_weak [count]
  local count="${1:-${RHCSA_PRACTICE_SIZE:-20}}" t sd used_spare=0 rootdisk ndisk
  sd="$(spare_disk_tasks)"; _is_spare() { grep -qx "$1" <<<"$sd"; }
  # Count truly-bare spare disks exactly the way ensure_spare_disk picks them:
  # a whole disk with NO partitions/children and not mounted. This also excludes
  # the system disk even on LVM installs, where the old PKNAME-of-/ detection
  # returned empty (so the system disk was wrongly counted as a spare, letting
  # the composer seed one disk-task too many -> an occasional storage/filesystems
  # practice failure when that extra task could not get a disk).
  ndisk=0
  while read -r _d; do
    [[ -n "$_d" ]] || continue
    [[ "$(lsblk -no NAME "/dev/$_d" 2>/dev/null | wc -l)" -eq 1 ]] || continue          # has partitions/children
    [[ -z "$(lsblk -rno MOUNTPOINT "/dev/$_d" 2>/dev/null | tr -d '[:space:]')" ]] || continue  # mounted
    ((ndisk++))
  done < <(lsblk -dnro NAME,TYPE 2>/dev/null | awk '$2=="disk"{print $1}')
  local out=() grp; declare -A grpused
  while read -r t; do
    [[ -z "$t" ]] && continue
    task_exists "$t" || continue
    grp="$(_task_conflict_group "$t")"
    [[ -n "$grp" && -n "${grpused[$grp]:-}" ]] && continue
    if _is_spare "$t"; then (( used_spare >= ndisk )) && continue; ((used_spare++)); fi
    out+=("$t"); [[ -n "$grp" ]] && grpused[$grp]=1
    (( ${#out[@]} >= count )) && break
  done < <(_weak_candidates "$RHCSA_STATE/history.jsonl")
  printf '%s\n' "${out[@]}"
}
