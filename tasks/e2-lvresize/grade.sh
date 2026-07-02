#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# vo + its data pre-exist (seeded at 200 MiB); points are for the resize to
# 300 MiB only (290-310 MiB acceptable per the answer key). Doing nothing = 0.
ckpt "vo extended to ~300 MiB (was 200)"               7 lv_size_between /dev/myvol/vo 290 310
ckpt_expr "filesystem grew to use the new space"       3 '[ "$(df -m --output=size /mnt/vo 2>/dev/null | tail -1 | tr -d " ")" -ge 270 ]'
ckpt_expr "original data preserved through the resize"  2 'grep -q "important data do not lose" /mnt/vo/data.txt 2>/dev/null && [ "$(lvs --noheadings -o lv_size --units m --nosuffix /dev/myvol/vo 2>/dev/null | tr -d " " | cut -d. -f1)" -ge 290 ]'
