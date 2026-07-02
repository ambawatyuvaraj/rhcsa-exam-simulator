#!/usr/bin/env bash
systemctl disable --now httpd >/dev/null 2>&1
rm -rf /var/www/html/pkgrepo/repodata 2>/dev/null
firewall-cmd --remove-service=http --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
exit 0
