#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/mnt/$MP is mounted as nfs read-only" 6 \
  'findmnt -rn /mnt/'"$MP"' | grep -qi nfs && findmnt -no OPTIONS /mnt/'"$MP"' | grep -qw ro'
ckpt_expr "fstab persists the read-only NFS mount" 4 \
  'grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -q "/exports/ro" && grep -vE "^\s*#" /etc/fstab | grep "/mnt/'"$MP"'" | grep -qw ro'
