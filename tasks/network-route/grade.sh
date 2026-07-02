#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "static route to $NET via $GW configured on rhcsart" 6 \
  'nmcli -g ipv4.routes con show rhcsart 2>/dev/null | grep -q "'"$NET"'" && nmcli -g ipv4.routes con show rhcsart 2>/dev/null | grep -q "'"$GW"'"'
