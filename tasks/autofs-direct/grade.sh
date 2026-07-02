#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "autofs is enabled and active" 3 svc_ok autofs
ckpt_expr "/mnt/$MP automounts the NFS export on access" 7 \
  'ls /mnt/'"$MP"'/README >/dev/null 2>&1 && findmnt /mnt/'"$MP"' >/dev/null 2>&1'
