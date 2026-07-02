#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal cut -d: -f$F output" 10 \
  'diff <(cut -d: -f'"$F"' /etc/passwd) /root/'"$OUT"' >/dev/null 2>&1'
