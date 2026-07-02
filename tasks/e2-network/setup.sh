#!/usr/bin/env bash
# spare dummy interface (persists across reboot via a boot unit)
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

# SAFETY: pre-create the connection ALREADY PINNED to the dummy rhcsa0, unconfigured.
# The student configures THIS profile (locked to rhcsa0 by interface-name), so a mistake
# can never attach a static IP to the management NIC and knock the node off the network.
nmcli -t -f NAME con show 2>/dev/null | grep -qx rhcsa0 && nmcli con delete rhcsa0 >/dev/null 2>&1
nmcli con add type ethernet con-name rhcsa0 ifname rhcsa0 \
      ipv4.method disabled ipv6.method disabled \
      connection.autoconnect no >/dev/null 2>&1

# Defense-in-depth: make the management NIC's profile win its own device on boot,
# so even a stray unbound profile can't steal it during autoconnect.
mgmtdev="$(ip route show default 2>/dev/null | awk '{print $5; exit}')"
mgmtcon="$(nmcli -t -f NAME,DEVICE con show --active 2>/dev/null | awk -F: -v d="$mgmtdev" '$2==d{print $1; exit}')"
[ -n "$mgmtcon" ] && nmcli con mod "$mgmtcon" connection.autoconnect yes connection.autoconnect-priority 100 2>/dev/null

# save the current hostname so teardown can restore the node's identity
mkdir -p /var/lib/rhcsa-sim
{ hostnamectl --static 2>/dev/null || cat /etc/hostname 2>/dev/null || hostname; } > /var/lib/rhcsa-sim/e2-network.hostbak 2>/dev/null
echo "f08-network: spare interface rhcsa0 ready, with a connection profile 'rhcsa0' pinned to it (configure that profile)"
exit 0
