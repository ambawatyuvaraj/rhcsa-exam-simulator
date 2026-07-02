#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT captured os-release from container" 6 'grep -q "NAME=" /root/'"$OUT"''
