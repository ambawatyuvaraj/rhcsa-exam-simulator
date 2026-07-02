#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Note: `nmcli -g` escapes the colons in IPv6 addresses (2001\:db8\:...), so
# disable escaping (-e no) and strip any backslashes before matching.
ckpt_expr "connection rhcsa6 has IPv6 $IP6/64" 8 \
  'nmcli -e no -g ipv6.addresses con show rhcsa6 2>/dev/null | tr -d "\\\\" | grep -q "'"$IP6"'/64"'
