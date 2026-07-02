#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "start prints starting"  3 '[ "$(/usr/local/bin/'"$SCRIPT"' start 2>/dev/null)" = starting ]'
ckpt_expr "stop prints stopping"   3 '[ "$(/usr/local/bin/'"$SCRIPT"' stop 2>/dev/null)" = stopping ]'
ckpt_expr "status prints status"   3 '[ "$(/usr/local/bin/'"$SCRIPT"' status 2>/dev/null)" = status ]'
