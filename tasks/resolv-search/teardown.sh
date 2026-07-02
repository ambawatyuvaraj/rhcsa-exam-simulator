#!/usr/bin/env bash
nmcli con delete rhcsasrch 2>/dev/null
systemctl disable --now resolv-search-dummy 2>/dev/null
rm -f /etc/systemd/system/resolv-search-dummy.service
systemctl daemon-reload 2>/dev/null
ip link del rhcsasrch 2>/dev/null
exit 0
