#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "ISO is mounted iso9660 at /mnt/$MP" 5 \
  '[ "$(findmnt -no FSTYPE /mnt/'"$MP"' 2>/dev/null)" = iso9660 ]'
ckpt_expr "fstab loop-mounts the ISO read-only" 5 \
  'grep -vE "^\s*#" /etc/fstab | grep "/root/'"$ISO"'.iso" | grep "/mnt/'"$MP"'" | grep -q loop'
