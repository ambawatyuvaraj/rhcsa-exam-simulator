#!/usr/bin/env bash
systemctl enable --now firewalld >/dev/null 2>&1
firewall-cmd --permanent --add-service="$SVC" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
echo "firewall-remove-service: firewalld active, $SVC service currently allowed"
exit 0
