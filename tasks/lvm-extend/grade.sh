#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "lvext size is between 580 and 620 MiB" 6 lv_size_between /dev/vgext/lvext 580 620
ckpt_expr "filesystem was grown to match" 4 \
  '[ "$(df -m --output=size /mnt/lvext 2>/dev/null | tail -1 | tr -d " ")" -ge 540 ]'
