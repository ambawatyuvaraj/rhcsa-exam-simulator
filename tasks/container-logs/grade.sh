#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT contains container $CN log output" 6 'grep -q RHCSA-LOG-MARKER /root/'"$OUT"''
