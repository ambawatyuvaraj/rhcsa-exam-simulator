#!/usr/bin/env bash
sed -i "/$SRV/d" /etc/chrony.conf 2>/dev/null
systemctl restart chronyd 2>/dev/null
exit 0
