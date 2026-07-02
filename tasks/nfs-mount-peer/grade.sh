#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/mnt/peernfs is mounted as nfs"       6 'findmnt -rn /mnt/peernfs | grep -qi nfs'
ckpt_expr "fstab persists the NFS mount"         4 \
  'grep -vE "^[[:space:]]*#" /etc/fstab | grep "/mnt/peernfs" | grep -qi "/exports/nodeshare"'
