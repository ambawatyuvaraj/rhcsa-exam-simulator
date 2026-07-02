#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT exists and is non-empty" 2 '[ -s /root/'"$OUT"' ]'
# The recorded name must match the comm of the current highest-%cpu process.
ckpt_expr "/root/$OUT names the top-CPU process" 4 \
  'top="$(ps -eo comm --sort=-%cpu --no-headers 2>/dev/null | head -1 | tr -d " ")"; got="$(head -1 /root/'"$OUT"' 2>/dev/null | tr -d " ")"; [ -n "$got" ] && [ "$got" = "$top" ]'
