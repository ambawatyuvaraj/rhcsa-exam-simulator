#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "DNS server $DNS1 configured on rhcsadns" 3 \
  'nmcli -g ipv4.dns con show rhcsadns 2>/dev/null | grep -q "'"$DNS1"'"'
ckpt_expr "DNS server $DNS2 configured on rhcsadns" 3 \
  'nmcli -g ipv4.dns con show rhcsadns 2>/dev/null | grep -q "'"$DNS2"'"'
