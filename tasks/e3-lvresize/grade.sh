#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# database starts at 50 extents (400 MiB, created by the LVM task); this task
# resizes it to 500 MiB. 500 MiB is not a whole multiple of the 8 MiB PE, so a
# correct lvextend -L 500M rounds up to 63 extents (504 MiB). Accept ~490-520.
ckpt "database resized to ~500 MiB"                   8 lv_size_between /dev/datastore/database 490 520
ckpt_expr "filesystem grew to use the new space"      4 '[ "$(df -m --output=size /mnt/education 2>/dev/null | tail -1 | tr -d " ")" -ge 450 ]'
