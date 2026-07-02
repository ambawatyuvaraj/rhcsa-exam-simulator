#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Resize task: the LV + data pre-exist, so points are awarded ONLY for the resize
# work (a student who does nothing scores 0). The data check is gated on the LV
# having actually grown, so losing data during the resize is still penalised.
ckpt "wlogic extended to ~800 MiB (was 300)"           7 lv_size_between /dev/wgroup/wlogic 780 820
ckpt_expr "filesystem grew to use the new space"       3 '[ "$(df -m --output=size /mnt/wlogic 2>/dev/null | tail -1 | tr -d " ")" -ge 700 ]'
ckpt_expr "original data preserved through the resize"  2 'grep -q "important data do not lose" /mnt/wlogic/data.txt 2>/dev/null && [ "$(lvs --noheadings -o lv_size --units m --nosuffix /dev/wgroup/wlogic 2>/dev/null | tr -d " " | cut -d. -f1)" -ge 780 ]'
