#!/usr/bin/env bash
# Provide a dedicated spare dummy interface + placeholder NM connection (rhcsagw).
cat >/etc/systemd/system/network-gateway-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsagw)
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsagw type dummy
ExecStartPost=/usr/sbin/ip link set rhcsagw up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsagw >/dev/null 2>&1 || ip link add rhcsagw type dummy 2>/dev/null
ip link set rhcsagw up 2>/dev/null
systemctl enable network-gateway-dummy.service >/dev/null 2>&1
nmcli con delete rhcsagw >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsagw con-name rhcsagw \
  ipv4.method manual ipv4.addresses 192.0.2.40/24 ipv6.method ignore >/dev/null 2>&1
echo "network-gateway: spare interface rhcsagw and placeholder connection seeded"
exit 0
