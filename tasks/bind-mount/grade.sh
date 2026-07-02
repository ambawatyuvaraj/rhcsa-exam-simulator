#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/mnt/$MP shows the bound source content" 5 \
  'is_mounted /mnt/'"$MP"' && [ -f /mnt/'"$MP"'/marker ]'
ckpt_expr "fstab has a bind entry for /mnt/$MP" 5 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -qw bind'
