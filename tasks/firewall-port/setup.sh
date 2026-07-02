#!/usr/bin/env bash
systemctl enable --now firewalld >/dev/null 2>&1
firewall-cmd --permanent --remove-port="$FWPORT"/tcp >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
echo "firewall-port: firewalld active, $FWPORT/tcp not yet open"
exit 0
