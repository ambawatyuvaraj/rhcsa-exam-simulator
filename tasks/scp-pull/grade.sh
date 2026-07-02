#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT exists" 2 '[ -s /root/'"$OUT"' ]'
ckpt_expr "/root/$OUT is identical to /etc/os-release" 4 'diff -q /etc/os-release /root/'"$OUT"' >/dev/null 2>&1'
