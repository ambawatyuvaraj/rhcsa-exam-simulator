#!/usr/bin/env bash
nmcli con delete rhcsa0 >/dev/null 2>&1
systemctl disable --now rhcsa-dummy.service 2>/dev/null
rm -f /etc/systemd/system/rhcsa-dummy.service; systemctl daemon-reload 2>/dev/null
ip link del rhcsa0 2>/dev/null
# restore the saved hostname (the node's real identity); fall back to node1.example.com
host="$(cat /var/lib/rhcsa-sim/e2-network.hostbak 2>/dev/null)"
[ -n "$host" ] || host=node1.example.com
hostnamectl set-hostname "$host" 2>/dev/null
rm -f /var/lib/rhcsa-sim/e2-network.hostbak 2>/dev/null
exit 0
