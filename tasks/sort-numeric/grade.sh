#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal sort -n output" 10 \
  'diff <(sort -n /opt/nums.txt) /root/'"$OUT"' >/dev/null 2>&1'
