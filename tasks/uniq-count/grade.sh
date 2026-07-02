#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal 'sort | uniq -c' output" 10 \
  'diff <(sort /opt/dups.txt | uniq -c) /root/'"$OUT"' >/dev/null 2>&1'
