#!/usr/bin/env bash
systemctl enable --now firewalld >/dev/null 2>&1
firewall-cmd --permanent --remove-rich-rule="rule family=\"ipv4\" source address=\"$FWSRC\" service name=\"ssh\" accept" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
echo "firewall-richrule: firewalld active, rich rule for $FWSRC not yet present"
exit 0
