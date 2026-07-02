#!/usr/bin/env bash
# Provide a dedicated spare dummy interface + placeholder NM connection (rhcsaauto).
cat >/etc/systemd/system/nmcli-autoconnect-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsaauto)
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsaauto type dummy
ExecStartPost=/usr/sbin/ip link set rhcsaauto up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsaauto >/dev/null 2>&1 || ip link add rhcsaauto type dummy 2>/dev/null
ip link set rhcsaauto up 2>/dev/null
systemctl enable nmcli-autoconnect-dummy.service >/dev/null 2>&1
nmcli con delete rhcsaauto >/dev/null 2>&1
nmcli con add type ethernet ifname rhcsaauto con-name rhcsaauto \
  ipv4.method manual ipv4.addresses 192.0.2.50/24 ipv6.method ignore \
  connection.autoconnect yes >/dev/null 2>&1
echo "nmcli-autoconnect: spare interface rhcsaauto seeded with autoconnect=yes"
exit 0
