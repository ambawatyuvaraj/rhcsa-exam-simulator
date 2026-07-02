#!/usr/bin/env bash
firewall-cmd --permanent --remove-rich-rule="rule family=\"ipv4\" source address=\"$FWSRC\" service name=\"ssh\" accept" >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
exit 0
