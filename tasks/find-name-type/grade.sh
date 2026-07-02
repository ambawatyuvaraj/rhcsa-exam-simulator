#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "list equals find -type f -name '*.$EXT' output" 10 \
  'diff <(find /opt/ntsrc -type f -name "*.'"$EXT"'" | sort) <(sort /root/'"$OUT"' 2>/dev/null) >/dev/null 2>&1'
