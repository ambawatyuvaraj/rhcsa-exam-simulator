#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "defines a greet function" 2 'grep -Eq "(^|[[:space:]])(function[[:space:]]+greet|greet[[:space:]]*\(\))" /usr/local/bin/'"$SCRIPT"
ckpt_expr "prints Hello, World!" 4 '[ "$(/usr/local/bin/'"$SCRIPT"' World 2>/dev/null)" = "Hello, World!" ]'
ckpt_expr "uses its argument" 2 '[ "$(/usr/local/bin/'"$SCRIPT"' Linux 2>/dev/null)" = "Hello, Linux!" ]'
