#!/usr/bin/env bash
# Provide a dedicated spare dummy interface + placeholder NM connection (rhcsa2ip).
cat >/etc/systemd/system/network-secondary-ip-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsa2ip)
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsa2ip type dummy
ExecStartPost=/usr/sbin/ip link set rhcsa2ip up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsa2ip >/dev/null 2>&1 || ip link add rhcsa2ip type dummy 2>/dev/null
ip link set rhcsa2ip up 2>/dev/null
systemctl enable network-secondary-ip-dummy.service >/dev/null 2>&1
nmcli con delete rhcsa2ip >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsa2ip con-name rhcsa2ip \
  ipv4.method manual ipv4.addresses 192.0.2.30/24 ipv6.method ignore >/dev/null 2>&1
echo "network-secondary-ip: spare interface rhcsa2ip and placeholder connection seeded"
exit 0
