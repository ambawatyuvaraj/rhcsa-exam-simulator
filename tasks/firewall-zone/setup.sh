#!/usr/bin/env bash
systemctl enable --now firewalld >/dev/null 2>&1
# Dedicated dummy NIC that persists across reboot, so changing ITS zone never
# affects the interface you are connected through (or the cross-node services).
cat >/etc/systemd/system/rhcsa-fwnic.service <<'UNIT'
[Unit]
Description=RHCSA simulator spare dummy NIC (rhcsafw)
Before=firewalld.service NetworkManager.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/ip link add rhcsafw type dummy
ExecStart=/usr/sbin/ip link set rhcsafw up
ExecStop=-/usr/sbin/ip link del rhcsafw
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload >/dev/null 2>&1
systemctl enable --now rhcsa-fwnic.service >/dev/null 2>&1
ip link show rhcsafw >/dev/null 2>&1 || { ip link add rhcsafw type dummy 2>/dev/null; ip link set rhcsafw up 2>/dev/null; }
# Start the dummy NIC in the default zone (candidate must move it).
firewall-cmd --permanent --zone=public --remove-interface=rhcsafw >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null 2>&1
echo "firewall-zone: dummy NIC rhcsafw present, currently in the default zone"
exit 0
