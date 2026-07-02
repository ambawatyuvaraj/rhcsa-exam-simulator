#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "uses positional args correctly" 8 '[ "$(/usr/local/bin/'"$SCRIPT"' alpha beta 2>/dev/null)" = "'"$WORD"' alpha beta" ]'
