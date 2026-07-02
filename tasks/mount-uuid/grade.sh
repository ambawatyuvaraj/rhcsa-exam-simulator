#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "mounted & persistent at /mnt/$MP" 6 mount_persistent "/mnt/$MP"
ckpt_expr "fstab entry uses a UUID for this mount" 4 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -q "UUID="'
