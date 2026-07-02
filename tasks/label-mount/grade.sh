#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "filesystem is mounted and in fstab at /mnt/$MP" 5 mount_persistent "/mnt/$MP"
ckpt_expr "fstab references the filesystem by LABEL=$LBL" 5 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -qE "LABEL=\"?'"$LBL"'\"?([[:space:]])"'
