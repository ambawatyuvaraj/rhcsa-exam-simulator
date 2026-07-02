#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "chrony.conf has an allow line"        4 'grep -qE "^allow" /etc/chrony.conf'
ckpt_expr "chrony.conf has a local stratum line" 4 'grep -qE "^local stratum" /etc/chrony.conf'
ckpt "chronyd is enabled and active"             2 svc_ok chronyd
ckpt_expr "firewall permits NTP"                 2 'firewall-cmd --permanent --list-services 2>/dev/null | tr " " "\n" | grep -qx ntp || firewall-cmd --list-services 2>/dev/null | tr " " "\n" | grep -qx ntp'
