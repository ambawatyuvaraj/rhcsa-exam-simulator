#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Disk-agnostic: the ext4 filesystem may live on whichever spare the candidate used,
# so verify by label (unique per task) rather than a pre-claimed device.
ckpt_expr "an ext4 filesystem exists (not reformatted away)" 3 \
  'blkid -t TYPE=ext4 -o device 2>/dev/null | grep -q .'
ckpt_expr "an ext4 filesystem is labelled $LBL" 5 \
  'd="$(blkid -L "'"$LBL"'" 2>/dev/null)"; [ -n "$d" ] && [ "$(blkid -o value -s TYPE "$d" 2>/dev/null)" = ext4 ]'
