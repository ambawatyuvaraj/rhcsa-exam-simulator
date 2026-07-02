#!/usr/bin/env bash
createrepo_c /var/www/html/pkgrepo >/dev/null 2>&1
restorecon -R /var/www/html/pkgrepo >/dev/null 2>&1
systemctl enable --now httpd >/dev/null 2>&1
firewall-cmd --add-service=http --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
