#!/usr/bin/env bash
# Provide a dedicated spare dummy interface + placeholder NM connection (rhcsadns).
cat >/etc/systemd/system/network-dns-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsadns)
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsadns type dummy
ExecStartPost=/usr/sbin/ip link set rhcsadns up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsadns >/dev/null 2>&1 || ip link add rhcsadns type dummy 2>/dev/null
ip link set rhcsadns up 2>/dev/null
systemctl enable network-dns-dummy.service >/dev/null 2>&1
nmcli con delete rhcsadns >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsadns con-name rhcsadns \
  ipv4.method manual ipv4.addresses 192.0.2.10/24 ipv6.method ignore >/dev/null 2>&1
echo "network-dns: spare interface rhcsadns and placeholder connection seeded"
exit 0
