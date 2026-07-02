#!/usr/bin/env bash
nmcli con delete rhcsagw 2>/dev/null
systemctl disable --now network-gateway-dummy 2>/dev/null
rm -f /etc/systemd/system/network-gateway-dummy.service
systemctl daemon-reload 2>/dev/null
ip link del rhcsagw 2>/dev/null
exit 0
