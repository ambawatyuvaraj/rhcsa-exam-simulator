#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "reports dir for /etc" 3 '[ "$(/usr/local/bin/'"$SCRIPT"' /etc 2>/dev/null)" = dir ]'
ckpt_expr "reports file for /etc/hostname" 3 '[ "$(/usr/local/bin/'"$SCRIPT"' /etc/hostname 2>/dev/null)" = file ]'
ckpt_expr "reports other for a nonexistent path" 3 '[ "$(/usr/local/bin/'"$SCRIPT"' /nope-'"$RANDOM"' 2>/dev/null)" = other ]'
