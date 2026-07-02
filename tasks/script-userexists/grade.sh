#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "prints present for root" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' root 2>/dev/null)" = present ]'
ckpt_expr "prints absent for a nonexistent user" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' nosuchuser'"$RANDOM"' 2>/dev/null)" = absent ]'
