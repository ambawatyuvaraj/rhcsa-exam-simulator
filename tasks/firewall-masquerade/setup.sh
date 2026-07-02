#!/usr/bin/env bash
systemctl enable --now firewalld >/dev/null 2>&1
firewall-cmd --permanent --remove-masquerade >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
echo "firewall-masquerade: firewalld active, masquerade not yet enabled"
exit 0
