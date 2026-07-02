#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Disk-agnostic: accept the MSDOS table + primary partition on whichever spare was used.
_mbr_part_on_spare() {
  local d t sz lo hi want="${SZ:-0}"
  lo=$((want*80/100)); hi=$((want*130/100))
  while read -r d t; do
    case "$t" in disk|loop) ;; *) continue ;; esac
    lsblk -rno MOUNTPOINT "/dev/$d" 2>/dev/null | grep -qE '^/($|boot)' && continue
    parted -s "/dev/$d" print 2>/dev/null | grep -qi 'Partition Table: msdos' || continue
    while read -r sz; do
      [ -n "$sz" ] || continue
      if [ "$want" -gt 0 ] 2>/dev/null; then
        [ "$sz" -ge "$lo" ] && [ "$sz" -le "$hi" ] && return 0
      else
        return 0
      fi
    done < <(lsblk -brno SIZE,TYPE "/dev/$d" 2>/dev/null | awk '$2=="part"{print int($1/1048576)}')
  done < <(lsblk -dnro NAME,TYPE 2>/dev/null)
  return 1
}
ckpt_expr "an MSDOS spare disk has a ~${SZ} MiB primary partition" 8 '_mbr_part_on_spare'
