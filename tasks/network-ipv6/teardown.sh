#!/usr/bin/env bash
nmcli con delete rhcsa6 2>/dev/null
systemctl disable --now rhcsa6-dummy 2>/dev/null
rm -f /etc/systemd/system/rhcsa6-dummy.service
systemctl daemon-reload 2>/dev/null
ip link del rhcsa6 2>/dev/null
exit 0
