#!/usr/bin/env bash
nmcli con delete rhcsa2ip 2>/dev/null
systemctl disable --now network-secondary-ip-dummy 2>/dev/null
rm -f /etc/systemd/system/network-secondary-ip-dummy.service
systemctl daemon-reload 2>/dev/null
ip link del rhcsa2ip 2>/dev/null
exit 0
