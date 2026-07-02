#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "connection 'rhcsa0' exists"                 2 'nmcli -t -f NAME con show 2>/dev/null | grep -qx rhcsa0'
ckpt_expr "IPv4 address 172.25.250.100/24 configured"  4 'nmcli -g ipv4.addresses con show rhcsa0 2>/dev/null | grep -q "172.25.250.100/24"'
ckpt_expr "IPv4 gateway 172.25.250.254 configured"     2 'nmcli -g ipv4.gateway con show rhcsa0 2>/dev/null | grep -q "172.25.250.254"'
ckpt_expr "DNS server 172.25.250.254 configured"       1 'nmcli -g ipv4.dns con show rhcsa0 2>/dev/null | grep -q "172.25.250.254"'
ckpt_expr "IPv4 method is manual"                       2 'nmcli -g ipv4.method con show rhcsa0 2>/dev/null | grep -qi manual'
ckpt_expr "connection autoconnects at boot"             1 'nmcli -g connection.autoconnect con show rhcsa0 2>/dev/null | grep -qi yes'
