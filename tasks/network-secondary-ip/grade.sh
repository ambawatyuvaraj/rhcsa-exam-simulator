#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "primary IPv4 192.0.2.30/24 still present on rhcsa2ip" 2 \
  'nmcli -g ipv4.addresses con show rhcsa2ip 2>/dev/null | grep -q "192.0.2.30/24"'
ckpt_expr "secondary IPv4 $IP/24 added to rhcsa2ip" 4 \
  'nmcli -g ipv4.addresses con show rhcsa2ip 2>/dev/null | grep -q "'"$IP"'/24"'
