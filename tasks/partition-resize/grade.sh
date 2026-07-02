#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/mnt/$MP is mounted" 3 is_mounted "/mnt/$MP"
ckpt_expr "filesystem at /mnt/$MP is at least ~350 MiB" 7 \
  "[ \"\$(df -BM --output=size '/mnt/$MP' 2>/dev/null | tail -1 | tr -dc '0-9')\" -ge 350 ]"
