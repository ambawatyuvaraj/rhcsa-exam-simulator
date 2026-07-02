#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT exists and is non-empty" 4 '[ -s /root/'"$OUT"' ]'
ckpt_expr "/root/$OUT lists the failed unit" 4 'grep -q rhcsa-failunit /root/'"$OUT"''
