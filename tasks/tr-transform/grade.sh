#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal tr a-z A-Z output" 10 \
  'diff <(tr "a-z" "A-Z" < /opt/text.txt) /root/'"$OUT"' >/dev/null 2>&1'
