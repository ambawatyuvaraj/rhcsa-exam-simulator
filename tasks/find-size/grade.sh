#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "list equals find -size +10k -size -100k output" 10 \
  'diff <(find /opt/sizesrc -type f -size +10k -size -100k | sort) <(sort /root/'"$OUT"' 2>/dev/null) >/dev/null 2>&1'
