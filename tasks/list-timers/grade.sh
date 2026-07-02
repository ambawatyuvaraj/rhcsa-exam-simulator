#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT exists and is non-empty" 3 '[ -s /root/'"$OUT"' ]'
ckpt_expr "/root/$OUT lists timer units" 3 'grep -q timer /root/'"$OUT"''
