#!/usr/bin/env bash
sed -i "/^server $PEER_ROLE\.example\.com iburst/d" /etc/chrony.conf 2>/dev/null
sed -i '/^server node1\.example\.com iburst/d' /etc/chrony.conf 2>/dev/null
systemctl restart chronyd >/dev/null 2>&1
exit 0
