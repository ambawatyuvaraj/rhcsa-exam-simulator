#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "IPv4 address 172.25.250.100/24 on rhcsa0"   4 'nmcli -g ipv4.addresses con show rhcsa0 2>/dev/null | grep -q "172.25.250.100/24"'
ckpt_expr "IPv4 gateway 172.25.250.254 configured"     1 'nmcli -g ipv4.gateway con show rhcsa0 2>/dev/null | grep -q "172.25.250.254"'
ckpt_expr "DNS server 172.25.250.254 configured"       1 'nmcli -g ipv4.dns con show rhcsa0 2>/dev/null | grep -q "172.25.250.254"'
ckpt_expr "manual + autoconnect + bound to rhcsa0"     1 'nmcli -g ipv4.method con show rhcsa0 2>/dev/null | grep -qi manual && nmcli -g connection.autoconnect con show rhcsa0 2>/dev/null | grep -qi yes && nmcli -g connection.interface-name con show rhcsa0 2>/dev/null | grep -qx rhcsa0'
ckpt_expr "hostname is serverb.example.com"            5 'hostnamectl --static 2>/dev/null | grep -qx serverb.example.com || hostname 2>/dev/null | grep -qx serverb.example.com'
