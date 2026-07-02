#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "sum 1..10 = 55" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' 10 2>/dev/null)" = 55 ]'
ckpt_expr "sum 1..5 = 15" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' 5 2>/dev/null)" = 15 ]'
