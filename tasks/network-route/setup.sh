#!/usr/bin/env bash
# Provide a dedicated spare dummy interface + placeholder NM connection (rhcsart).
cat >/etc/systemd/system/network-route-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsart)
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsart type dummy
ExecStartPost=/usr/sbin/ip link set rhcsart up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsart >/dev/null 2>&1 || ip link add rhcsart type dummy 2>/dev/null
ip link set rhcsart up 2>/dev/null
systemctl enable network-route-dummy.service >/dev/null 2>&1
nmcli con delete rhcsart >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsart con-name rhcsart \
  ipv4.method manual ipv4.addresses 192.0.2.20/24 ipv4.gateway 192.0.2.1 ipv6.method ignore >/dev/null 2>&1
echo "network-route: spare interface rhcsart and placeholder connection seeded"
exit 0
