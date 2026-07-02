#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Disk-agnostic: accept the GPT-named partition on whichever spare the candidate used.
_gpt_named_on_spare() {
  local d t
  while read -r d t; do
    case "$t" in disk|loop) ;; *) continue ;; esac
    lsblk -rno MOUNTPOINT "/dev/$d" 2>/dev/null | grep -qE '^/($|boot)' && continue
    parted -s "/dev/$d" print 2>/dev/null | grep -qi 'Partition Table: gpt' || continue
    parted -s "/dev/$d" print 2>/dev/null | grep -qiw "$PNAME" && return 0
  done < <(lsblk -dnro NAME,TYPE 2>/dev/null)
  return 1
}
ckpt_expr "a GPT partition named $PNAME exists on a spare disk" 8 '_gpt_named_on_spare'
