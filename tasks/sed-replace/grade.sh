#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/$OUT exists" 2 path_exists "/root/$OUT"
ckpt_expr "output matches canonical sed substitution" 6 \
  'diff <(sed "s/$OLD/$NEW/g" /opt/sedsrc.txt) /root/'"$OUT"' >/dev/null 2>&1'
ckpt_expr "original /opt/sedsrc.txt unchanged" 2 'grep -q -- "$OLD" /opt/sedsrc.txt'
