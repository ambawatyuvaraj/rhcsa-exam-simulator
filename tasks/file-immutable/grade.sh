#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$F has the immutable attribute" 6 \
  'lsattr /root/'"$F"' 2>/dev/null | grep -q "i"'
