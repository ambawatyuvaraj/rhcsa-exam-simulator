#!/usr/bin/env bash
nmcli con delete rhcsaauto 2>/dev/null
systemctl disable --now nmcli-autoconnect-dummy 2>/dev/null
rm -f /etc/systemd/system/nmcli-autoconnect-dummy.service
systemctl daemon-reload 2>/dev/null
ip link del rhcsaauto 2>/dev/null
exit 0
