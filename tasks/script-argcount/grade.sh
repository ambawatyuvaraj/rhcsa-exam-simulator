#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "exits non-zero with one arg" 3 '/usr/local/bin/'"$SCRIPT"' onlyone >/dev/null 2>&1; [ "$?" -ne 0 ]'
ckpt_expr "prints usage to stderr with wrong arg count" 3 '/usr/local/bin/'"$SCRIPT"' onlyone 2>&1 >/dev/null | grep -q "^usage:"'
ckpt_expr "prints ok with two args" 2 '[ "$(/usr/local/bin/'"$SCRIPT"' a b 2>/dev/null)" = ok ]'
ckpt_expr "exits zero with two args" 2 '/usr/local/bin/'"$SCRIPT"' a b >/dev/null 2>&1; [ "$?" -eq 0 ]'
