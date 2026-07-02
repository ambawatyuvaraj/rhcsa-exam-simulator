#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT is non-empty" 2 \
  '[ -s /root/'"$OUT"' ]'
ckpt_expr "/root/$OUT contains a size with a unit and names /var" 4 \
  'grep -qE "[0-9]+(\.[0-9]+)?[KMGT]" /root/'"$OUT"' && grep -q "/var" /root/'"$OUT"''
