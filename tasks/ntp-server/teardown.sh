#!/usr/bin/env bash
sed -i '/^allow 192\.168\.0\.0\/16/d' /etc/chrony.conf 2>/dev/null
sed -i '/^local stratum 10/d' /etc/chrony.conf 2>/dev/null
systemctl restart chronyd >/dev/null 2>&1
firewall-cmd --remove-service=ntp --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
exit 0
