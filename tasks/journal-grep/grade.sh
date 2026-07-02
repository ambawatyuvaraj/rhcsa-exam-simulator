#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT exists and is non-empty" 4 '[ -s /root/'"$OUT"' ]'
# Every non-empty line in the file must contain the requested string.
ckpt_expr "every line in /root/$OUT contains $STR" 4 \
  '[ -s /root/'"$OUT"' ] && ! grep -v "'"$STR"'" /root/'"$OUT"' | grep -q .'
