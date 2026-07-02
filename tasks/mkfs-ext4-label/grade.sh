#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "filesystem at /mnt/$MP is ext4"    3 fs_type "/mnt/$MP" ext4
ckpt "mounted & persistent at /mnt/$MP"  3 mount_persistent "/mnt/$MP"
ckpt_expr "fstab uses LABEL=$LBL" 2 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -q "LABEL='"$LBL"'"'
