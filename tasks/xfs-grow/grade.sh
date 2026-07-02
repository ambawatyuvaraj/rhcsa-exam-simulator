#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "LV $VG/$LV is between 480 and 560 MiB" 4 lv_size_between "$VG/$LV" 480 560
ckpt_expr "XFS at /mnt/$MP is mounted and grown (>=460 MiB)" 6 \
  '[ "$(findmnt -no FSTYPE /mnt/'"$MP"' 2>/dev/null)" = xfs ] && [ "$(df -m --output=size /mnt/'"$MP"' 2>/dev/null | tail -1 | tr -d " ")" -ge 460 ]'
