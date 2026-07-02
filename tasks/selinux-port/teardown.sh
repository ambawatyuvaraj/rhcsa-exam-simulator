#!/usr/bin/env bash
systemctl disable --now httpd >/dev/null 2>&1
semanage port -d -t http_port_t -p tcp 82 >/dev/null 2>&1
firewall-cmd --remove-port=82/tcp >/dev/null 2>&1
firewall-cmd --permanent --remove-port=82/tcp >/dev/null 2>&1
sed -i 's/^Listen 82/Listen 80/' /etc/httpd/conf/httpd.conf 2>/dev/null
rm -f /var/www/html/index.html 2>/dev/null
exit 0
