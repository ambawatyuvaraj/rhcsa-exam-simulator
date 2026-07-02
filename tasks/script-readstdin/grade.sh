#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "uppercases hello" 4 '[ "$(echo hello | /usr/local/bin/'"$SCRIPT"' 2>/dev/null)" = HELLO ]'
ckpt_expr "uppercases mixed input" 4 '[ "$(echo RedHat9 | /usr/local/bin/'"$SCRIPT"' 2>/dev/null)" = REDHAT9 ]'
