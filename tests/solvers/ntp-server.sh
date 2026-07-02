#!/usr/bin/env bash
grep -qE '^allow 192\.168\.0\.0/16' /etc/chrony.conf || echo 'allow 192.168.0.0/16' >>/etc/chrony.conf
grep -qE '^local stratum 10' /etc/chrony.conf || echo 'local stratum 10' >>/etc/chrony.conf
systemctl enable --now chronyd >/dev/null 2>&1
firewall-cmd --add-service=ntp --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
