#!/usr/bin/env bash
nmcli con delete rhcsa0 >/dev/null 2>&1
systemctl disable --now rhcsa-dummy.service 2>/dev/null
rm -f /etc/systemd/system/rhcsa-dummy.service; systemctl daemon-reload 2>/dev/null
ip link del rhcsa0 2>/dev/null
hostnamectl set-hostname localhost.localdomain 2>/dev/null
exit 0
