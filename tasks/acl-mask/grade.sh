#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/$F exists" 2 path_exists "/root/$F"
ckpt_expr "ACL mask is r-x" 6 \
  'getfacl -p /root/'"$F"' 2>/dev/null | grep -q "^mask::r-x"'
