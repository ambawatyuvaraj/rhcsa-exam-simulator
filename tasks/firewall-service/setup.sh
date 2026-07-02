#!/usr/bin/env bash
systemctl enable --now firewalld >/dev/null 2>&1
firewall-cmd --permanent --remove-service="$FWSVC" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
echo "firewall-service: firewalld active, $FWSVC not yet allowed"
exit 0
