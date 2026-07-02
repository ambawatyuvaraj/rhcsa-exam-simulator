#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "pretty hostname is $PH" 5 \
  'hostnamectl --pretty 2>/dev/null | grep -qx "$PH"'
