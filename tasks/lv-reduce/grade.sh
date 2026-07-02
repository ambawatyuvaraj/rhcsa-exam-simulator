#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "$LV reduced to ~300 MiB"            5 lv_size_between "/dev/$VG/$LV" 280 320
ckpt_expr "data file preserved at /mnt/$MP/important.txt" 5 \
  "grep -q rhcsa-important-data '/mnt/$MP/important.txt'"
