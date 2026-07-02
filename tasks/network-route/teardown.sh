#!/usr/bin/env bash
nmcli con delete rhcsart 2>/dev/null
systemctl disable --now network-route-dummy 2>/dev/null
rm -f /etc/systemd/system/network-route-dummy.service
systemctl daemon-reload 2>/dev/null
ip link del rhcsart 2>/dev/null
exit 0
