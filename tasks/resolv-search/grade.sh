#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "DNS search domain $DOM configured on rhcsasrch" 5 \
  'nmcli -g ipv4.dns-search con show rhcsasrch 2>/dev/null | grep -q "'"$DOM"'"'
