#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "filesystem is mounted and in fstab at /mnt/$MP" 5 mount_persistent "/mnt/$MP"
ckpt_expr "fstab entry for /mnt/$MP uses nofail" 5 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -qw nofail'
