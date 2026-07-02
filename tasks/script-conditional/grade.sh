#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "prints big for value above threshold" 5 '[ "$(/usr/local/bin/'"$SCRIPT"' '"$((THR+10))"' 2>/dev/null)" = big ]'
ckpt_expr "prints small for value below threshold" 5 '[ "$(/usr/local/bin/'"$SCRIPT"' '"$((THR-10))"' 2>/dev/null)" = small ]'
