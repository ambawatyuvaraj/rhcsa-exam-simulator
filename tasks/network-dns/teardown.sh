#!/usr/bin/env bash
nmcli con delete rhcsadns 2>/dev/null
systemctl disable --now network-dns-dummy 2>/dev/null
rm -f /etc/systemd/system/network-dns-dummy.service
systemctl daemon-reload 2>/dev/null
ip link del rhcsadns 2>/dev/null
exit 0
