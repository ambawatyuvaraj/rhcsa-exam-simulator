#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# 100 extents x 8 MiB PE = 800 MiB. Points are for the resize only (the LV is
# created by the LVM task), so doing nothing scores 0.
ckpt "database extended to ~100 extents (~800 MiB)"   8 lv_size_between /dev/datastore/database 780 820
ckpt_expr "filesystem grew to use the new space"      4 '[ "$(df -m --output=size /mnt/database 2>/dev/null | tail -1 | tr -d " ")" -ge 700 ]'
