#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "filesystem at /mnt/$MP is xfs"        4 fs_type "/mnt/$MP" xfs
ckpt "mounted & persistent at /mnt/$MP"     4 mount_persistent "/mnt/$MP"
ckpt_expr "fstab entry for /mnt/$MP uses UUID=" 4 \
  "grep -vE '^[[:space:]]*#' /etc/fstab | grep -E '[[:space:]]/mnt/$MP[[:space:]]' | grep -q 'UUID='"
