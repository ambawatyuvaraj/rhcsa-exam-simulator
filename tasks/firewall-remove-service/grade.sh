#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$SVC removed (runtime)" 3 \
  '! firewall-cmd --list-services 2>/dev/null | tr " " "\n" | grep -qx "'"$SVC"'"'
ckpt_expr "$SVC removed (permanent)" 3 \
  '! firewall-cmd --permanent --list-services 2>/dev/null | tr " " "\n" | grep -qx "'"$SVC"'"'
