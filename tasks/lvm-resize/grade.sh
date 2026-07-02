#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "logical volume vgroup/vo exists"         2 lv_exists vgroup vo
ckpt "vo size is between 290 and 310 MiB"      5 lv_size_between /dev/vgroup/vo 290 310
ckpt_expr "filesystem was grown to match"      3 '[ "$(df -m --output=size /mnt/vo 2>/dev/null | tail -1 | tr -d " ")" -ge 270 ]'
ckpt_expr "original data is still present"     2 'grep -q "important data do not lose" /mnt/vo/data.txt'
