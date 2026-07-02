#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

# This VM has several spare disks and the prompt says "identify it with lsblk", so accept
# the work on WHICHEVER spare the candidate used (not a pre-claimed one). Pass if any
# non-system whole disk holds a partition of about A MiB AND another of about B MiB.
_two_parts_on_any_spare() {
  local wa="${A:-0}" wb="${B:-0}" w1 w2 d t s i u1 u2 loose=0
  # If params didn't load (A/B unset), fall back to "any two partitions on a spare".
  [ "$wa" -gt 0 ] 2>/dev/null || loose=1
  [ "$wb" -gt 0 ] 2>/dev/null || loose=1
  if [ "$wa" -le "$wb" ] 2>/dev/null; then w1="$wa"; w2="$wb"; else w1="$wb"; w2="$wa"; fi
  while read -r d t; do
    case "$t" in disk|loop) ;; *) continue ;; esac
    # skip the system disk (its tree carries the / or /boot mountpoint)
    lsblk -rno MOUNTPOINT "/dev/$d" 2>/dev/null | grep -qE '^/($|boot)' && continue
    local parts=()
    while read -r s; do [ -n "$s" ] && parts+=("$s"); done \
      < <(lsblk -brno SIZE,TYPE "/dev/$d" 2>/dev/null | awk '$2=="part"{print int($1/1048576)}' | sort -n)
    [ "${#parts[@]}" -ge 2 ] || continue
    [ "$loose" = 1 ] && return 0
    u1=-1; u2=-1
    for i in "${!parts[@]}"; do
      s="${parts[$i]}"
      [ "$u1" -lt 0 ] && [ "$s" -ge $((w1*80/100)) ] && [ "$s" -le $((w1*130/100)) ] && { u1="$i"; break; }
    done
    for i in "${!parts[@]}"; do
      [ "$i" = "$u1" ] && continue
      s="${parts[$i]}"
      [ "$u2" -lt 0 ] && [ "$s" -ge $((w2*80/100)) ] && [ "$s" -le $((w2*130/100)) ] && { u2="$i"; break; }
    done
    [ "$u1" -ge 0 ] && [ "$u2" -ge 0 ] && return 0
  done < <(lsblk -dnro NAME,TYPE 2>/dev/null)
  return 1
}
ckpt_expr "two partitions (~${A} MiB and ~${B} MiB) on a spare disk" 8 '_two_parts_on_any_spare'
