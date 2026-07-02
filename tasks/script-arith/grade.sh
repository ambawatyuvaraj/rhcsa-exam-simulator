#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "7 + 5 = 12" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' 7 5 2>/dev/null)" = 12 ]'
ckpt_expr "'"$A"' + '"$B"' = '"$((A+B))"'" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' '"$A"' '"$B"' 2>/dev/null)" = '"$((A+B))"' ]'
