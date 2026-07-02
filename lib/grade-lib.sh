#!/usr/bin/env bash
# lib/grade-lib.sh — checkpoint assertion library for task grade.sh scripts.
#
# Usage inside a task's grade.sh:
#   source "$RHCSA_LIB/grade-lib.sh"
#   ckpt "Group sysmgrs exists" 3 group_exists sysmgrs
#   ckpt "natasha in sysmgrs"   3 user_in_group natasha sysmgrs
#   ckpt_end
#
# ckpt prints one JSON object per line to stdout:
#   {"checkpoint":"...","max":N,"points":N,"ok":true|false,"detail":"..."}
# A task earns full marks only if every checkpoint is ok (enforced by the
# reporter), but each checkpoint is reported individually for feedback.

LAST_DETAIL=""

_json_escape() {  # escape a string for embedding in JSON
  local s="$1"
  s="${s//\\/\\\\}"; s="${s//\"/\\\"}"
  s="${s//$'\t'/ }"; s="${s//$'\n'/ }"; s="${s//$'\r'/}"
  printf '%s' "$s"
}

# ckpt "<description>" <max-points> <assertion-fn> [args...]
ckpt() {
  local desc="$1" max="$2"; shift 2
  LAST_DETAIL=""
  local pts=0 okstr="false"
  if "$@" >/dev/null 2>&1; then pts="$max"; okstr="true"; fi
  printf '{"checkpoint":"%s","max":%s,"points":%s,"ok":%s,"detail":"%s"}\n' \
    "$(_json_escape "$desc")" "$max" "$pts" "$okstr" "$(_json_escape "$LAST_DETAIL")"
}

# Convenience: assert a raw shell expression (string) is true.
ckpt_expr() {  # ckpt_expr "<desc>" <max> "<shell expression>"
  local desc="$1" max="$2" expr="$3"
  LAST_DETAIL="$expr"
  local pts=0 okstr="false"
  # Evaluate in a SUBSHELL with eval (not `bash -c`) so the expression can call
  # grade-lib helper functions (is_mounted, fstab_has, …) — a child `bash -c`
  # would not inherit them and such checks would silently fail.
  if ( eval "$expr" ) >/dev/null 2>&1; then pts="$max"; okstr="true"; fi
  printf '{"checkpoint":"%s","max":%s,"points":%s,"ok":%s,"detail":"%s"}\n' \
    "$(_json_escape "$desc")" "$max" "$pts" "$okstr" "$(_json_escape "$expr")"
}

# ============================================================================
# Assertion helpers — each returns 0 (pass) / non-zero (fail).
# They may set LAST_DETAIL with a human-readable note.
# ============================================================================

# -- Users / groups ----------------------------------------------------------
user_exists()   { id "$1" >/dev/null 2>&1; }
group_exists()  { getent group "$1" >/dev/null 2>&1; }
user_in_group() { id -nG "$1" 2>/dev/null | tr ' ' '\n' | grep -qx "$2"; }
user_uid()      { [[ "$(id -u "$1" 2>/dev/null)" == "$2" ]]; }
user_shell()    { [[ "$(getent passwd "$1" | cut -d: -f7)" == "$2" ]]; }
user_password() {  # user_password <user> <plaintext>  — verifies /etc/shadow hash
  local u="$1" p="$2" hash salt
  hash=$(getent shadow "$u" 2>/dev/null | cut -d: -f2)
  [[ -n "$hash" && "$hash" != "!"* && "$hash" != "*" ]] || { LAST_DETAIL="no password set"; return 1; }
  python3 - "$p" "$hash" <<'PY'
import crypt,sys
pw,h=sys.argv[1],sys.argv[2]
sys.exit(0 if crypt.crypt(pw,h)==h else 1)
PY
}
user_pw_maxdays() { [[ "$(chage -l "$1" 2>/dev/null | awk -F: '/Maximum/{gsub(/ /,"",$2);print $2}')" == "$2" ]]; }

# -- Files / permissions / ACL ----------------------------------------------
path_exists()   { [[ -e "$1" ]]; }
is_dir()        { [[ -d "$1" ]]; }
file_mode()     { [[ "$(stat -c '%a' "$1" 2>/dev/null)" == "$2" ]]; }
file_owner()    { [[ "$(stat -c '%U' "$1" 2>/dev/null)" == "$2" ]]; }
file_group()    { [[ "$(stat -c '%G' "$1" 2>/dev/null)" == "$2" ]]; }
has_setgid()    { [[ "$(stat -c '%a' "$1" 2>/dev/null)" == 2* ]] || stat -c '%A' "$1" 2>/dev/null | grep -q 's'; }
file_contains() { grep -Fq "$2" "$1" 2>/dev/null; }
file_regex()    { grep -Eq "$2" "$1" 2>/dev/null; }
acl_has()       { getfacl -p "$1" 2>/dev/null | grep -qx "$2"; }   # e.g. "user:harry:rw-"

# -- Packages / services -----------------------------------------------------
pkg_installed() { rpm -q "$1" >/dev/null 2>&1; }
svc_enabled()   { systemctl is-enabled "$1" >/dev/null 2>&1; }
svc_active()    { systemctl is-active "$1" >/dev/null 2>&1; }
svc_ok()        { svc_enabled "$1" && svc_active "$1"; }   # persistence + runtime

# -- Storage / mounts --------------------------------------------------------
is_mounted()      { findmnt -rn --target "$1" >/dev/null 2>&1 || mountpoint -q "$1"; }
fstab_has()       { grep -vE '^\s*#' /etc/fstab | grep -Eq "$1"; }
mount_persistent(){ is_mounted "$1" && fstab_has "([[:space:]]|^)$1([[:space:]])"; }
swap_active()     { swapon --show=NAME --noheadings 2>/dev/null | grep -q .; }
swap_total_min()  { [[ "$(free -m | awk '/Swap/{print $2}')" -ge "$1" ]]; }
lv_exists()       { lvs --noheadings -o lv_name "$1" 2>/dev/null | grep -qw "$2"; }   # vg lv
# Compare numerically ("16.00" -> 16). (A previous tr-based version deleted ALL
# zero characters, silently corrupting sizes like 10 -> 1 or 20 -> 2.)
vg_extent_size()  { [[ "$(vgs --noheadings --units m --nosuffix -o vg_extent_size "$1" 2>/dev/null | awk '{printf "%d",$1}')" == "$2" ]]; }
fs_type()         { [[ "$(findmnt -rn -o FSTYPE --target "$1" 2>/dev/null)" == "$2" ]]; }
# LV size within tolerance (MiB):  lv_size_between <vg/lv path> <min> <max>
lv_size_between() {
  local sz; sz=$(lvs --noheadings --units m --nosuffix -o lv_size "$1" 2>/dev/null | awk '{printf "%d",$1}')
  [[ -n "$sz" ]] || return 1
  LAST_DETAIL="size=${sz}MiB"
  [[ "$sz" -ge "$2" && "$sz" -le "$3" ]]
}

# -- SELinux / firewall ------------------------------------------------------
selinux_enforcing() { [[ "$(getenforce 2>/dev/null)" == "Enforcing" ]]; }
selinux_port()      { semanage port -l 2>/dev/null | grep -E "^$1\b" | grep -qw "$2"; }  # type proto/port via grep
selinux_port_tcp()  { semanage port -l 2>/dev/null | awk -v t="$1" '$1==t && $2=="tcp"' | grep -qw "$2"; }
fcontext_has()      { semanage fcontext -l 2>/dev/null | grep -q "$1"; }
sebool_on()         { [[ "$(getsebool "$1" 2>/dev/null | awk '{print $3}')" == "on" ]]; }
firewall_port()     { firewall-cmd --list-ports 2>/dev/null | tr ' ' '\n' | grep -qx "$1"; }
firewall_service()  { firewall-cmd --list-services 2>/dev/null | tr ' ' '\n' | grep -qx "$1"; }

# -- Scheduling / tuning / time ---------------------------------------------
crontab_has()    { crontab -l -u "$1" 2>/dev/null | grep -vE '^\s*#' | grep -Eq "$2"; }
tuned_active()   { [[ "$(tuned-adm active 2>/dev/null | sed 's/.*: //')" == "$1" ]]; }
# The exam objective is "set the recommended profile as the DEFAULT". That is
# the PERSISTED profile (/etc/tuned/active_profile), which survives reboots even
# if the Type=dbus tuned daemon isn't momentarily resident. Compare persisted
# profile to the recommendation (fall back to `tuned-adm active` parsing).
tuned_recommended_profile() {
  local cur rec
  rec="$(tuned-adm recommend 2>/dev/null)"
  cur="$(cat /etc/tuned/active_profile 2>/dev/null)"
  [[ -z "$cur" ]] && cur="$(tuned-adm active 2>/dev/null | sed 's/.*: //')"
  LAST_DETAIL="active=$cur recommended=$rec"
  [[ -n "$rec" && "$cur" == "$rec" ]]
}
tuned_is_recommended() { tuned_recommended_profile; }  # backward-compat alias
chrony_server()  { grep -vE '^\s*#' /etc/chrony.conf 2>/dev/null | grep -Eq "^(server|pool)\s+$1"; }

# -- Containers --------------------------------------------------------------
# Run a command as a given user (rootless), with a proper user session
# environment so `podman` and `systemctl --user` work. Requires lingering
# (or an active session) so /run/user/<uid> exists.
_uctl() {
  local u="$1"; shift
  local uid home
  uid="$(id -u "$u" 2>/dev/null)"
  home="$(getent passwd "$u" | cut -d: -f6)"
  runuser -u "$u" -- env HOME="$home" \
     XDG_RUNTIME_DIR="/run/user/$uid" \
     DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$uid/bus" \
     bash -lc "cd \"\$HOME\" 2>/dev/null; $*" 2>/dev/null
}
image_present()      { _uctl "$1" "podman image exists '$2'"; }
container_exists()   { _uctl "$1" "podman container exists '$2'"; }
user_unit_enabled()  { _uctl "$1" "systemctl --user is-enabled '$2'"; }
user_unit_active()   { _uctl "$1" "systemctl --user is-active '$2'"; }
linger_enabled()     { loginctl show-user "$1" -p Linger 2>/dev/null | grep -qi 'Linger=yes'; }

# -- Boot target -------------------------------------------------------------
default_target()  { [[ "$(systemctl get-default 2>/dev/null)" == "$1" ]]; }

# -- Journald ----------------------------------------------------------------
journal_persistent() { [[ -d /var/log/journal ]] && grep -qE '^\s*Storage\s*=\s*(persistent|auto)' /etc/systemd/journald.conf 2>/dev/null || [[ -d /var/log/journal ]]; }

ckpt_end() { :; }   # placeholder for symmetry / future use
