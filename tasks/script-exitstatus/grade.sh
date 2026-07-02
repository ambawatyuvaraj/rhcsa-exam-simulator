#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "prints exists for an existing path" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' /etc 2>/dev/null)" = exists ]'
ckpt_expr "prints missing for a nonexistent path" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' /nonexistent-'"$RANDOM"' 2>/dev/null)" = missing ]'
