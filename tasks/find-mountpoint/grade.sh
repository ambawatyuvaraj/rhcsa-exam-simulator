#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/$OUT exists" 2 path_exists "/root/$OUT"
ckpt_expr "/root/$OUT holds the / filesystem type" 4 \
  '[ "$(tr -d "[:space:]" </root/'"$OUT"' 2>/dev/null)" = "$(findmnt -no FSTYPE /)" ]'
