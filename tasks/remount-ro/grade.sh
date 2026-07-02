#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/mnt/$MP is still mounted" 3 is_mounted "/mnt/$MP"
ckpt_expr "/mnt/$MP is mounted read-only" 5 \
  'findmnt -no OPTIONS /mnt/'"$MP"' 2>/dev/null | grep -qw ro'
