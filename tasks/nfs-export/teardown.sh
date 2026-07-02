#!/usr/bin/env bash
rm -f /etc/exports.d/nodeshare.exports 2>/dev/null
sed -i '\#/exports/nodeshare#d' /etc/exports 2>/dev/null
exportfs -ra >/dev/null 2>&1
systemctl disable --now nfs-server >/dev/null 2>&1
userdel -rf remoteu >/dev/null 2>&1
rm -rf /exports/nodeshare 2>/dev/null
firewall-cmd --remove-service=nfs --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
exit 0
