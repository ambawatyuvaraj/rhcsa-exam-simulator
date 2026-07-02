#!/usr/bin/env bash
# Provide a spare dummy interface (persists across reboot via a boot unit).
cat >/etc/systemd/system/rhcsa-dummy.service <<UNIT
[Unit]
Description=RHCSA simulator spare dummy NIC
Before=NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsa0 type dummy
ExecStartPost=/usr/sbin/ip link set rhcsa0 up
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload 2>/dev/null
ip link show rhcsa0 >/dev/null 2>&1 || ip link add rhcsa0 type dummy 2>/dev/null
ip link set rhcsa0 up 2>/dev/null
systemctl enable rhcsa-dummy.service >/dev/null 2>&1
nmcli -t -f NAME con show 2>/dev/null | grep -qx rhcsa0 && nmcli con delete rhcsa0 >/dev/null 2>&1
echo "network-config: spare interface rhcsa0 ready"
exit 0
