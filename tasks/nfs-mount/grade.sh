#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "mounted at /mnt/$MP as nfs" 6 \
  'findmnt -rn /mnt/'"$MP"' | grep -qi nfs'
ckpt_expr "fstab persists the NFS mount" 4 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -qi "/exports/share2"'
