#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "IPv4 default gateway $GW configured on rhcsagw" 6 \
  'nmcli -g ipv4.gateway con show rhcsagw 2>/dev/null | grep -q "'"$GW"'"'
