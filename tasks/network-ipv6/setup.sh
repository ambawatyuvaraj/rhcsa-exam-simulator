#!/usr/bin/env bash
# Provide a dedicated spare dummy interface + placeholder NM connection (rhcsa6).
cat >/etc/systemd/system/rhcsa6-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsa6)
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsa6 type dummy
ExecStartPost=/usr/sbin/ip link set rhcsa6 up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsa6 >/dev/null 2>&1 || ip link add rhcsa6 type dummy 2>/dev/null
ip link set rhcsa6 up 2>/dev/null
systemctl enable rhcsa6-dummy.service >/dev/null 2>&1
nmcli con delete rhcsa6 >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsa6 con-name rhcsa6 \
  ipv4.method disabled ipv6.method manual ipv6.addresses ::99/64 >/dev/null 2>&1
echo "network-ipv6: spare interface rhcsa6 and placeholder connection seeded"
exit 0
