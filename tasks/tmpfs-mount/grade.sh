#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "tmpfs is mounted at /mnt/$MP" 5 \
  '[ "$(findmnt -no FSTYPE /mnt/'"$MP"' 2>/dev/null)" = tmpfs ]'
ckpt_expr "fstab has a sized tmpfs entry for /mnt/$MP" 5 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -qw tmpfs && grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -q "size="'
