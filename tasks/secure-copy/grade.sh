#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "copy matches /etc/hostname" 8 'diff /etc/hostname /root/'"$OUTF"' >/dev/null 2>&1'
