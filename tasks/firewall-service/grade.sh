#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "firewall allows {{FWSVC}} (runtime)" 4 firewall_service "$FWSVC"
ckpt_expr "permanent rule for {{FWSVC}}" 4 'firewall-cmd --permanent --list-services 2>/dev/null | tr " " "\n" | grep -qx '"$FWSVC"''
