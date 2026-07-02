#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal lines $A..$B of /etc/services" 10 \
  'diff <(sed -n "'"$A"','"$B"'p" /etc/services) /root/'"$OUT"' >/dev/null 2>&1'
