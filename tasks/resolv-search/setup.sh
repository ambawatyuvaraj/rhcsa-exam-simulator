#!/usr/bin/env bash
# Provide a dedicated spare dummy interface + placeholder NM connection (rhcsasrch).
cat >/etc/systemd/system/resolv-search-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsasrch)
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsasrch type dummy
ExecStartPost=/usr/sbin/ip link set rhcsasrch up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsasrch >/dev/null 2>&1 || ip link add rhcsasrch type dummy 2>/dev/null
ip link set rhcsasrch up 2>/dev/null
systemctl enable resolv-search-dummy.service >/dev/null 2>&1
nmcli con delete rhcsasrch >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsasrch con-name rhcsasrch \
  ipv4.method manual ipv4.addresses 192.0.2.60/24 ipv6.method ignore >/dev/null 2>&1
echo "resolv-search: spare interface rhcsasrch and placeholder connection seeded"
exit 0
