#!/usr/bin/env bash
mkdir -p /var/www/html
echo "<h1>hi</h1>" > /var/www/html/$F
chcon -t user_home_t /var/www/html/$F 2>/dev/null
echo "selinux-restorecon: seeded $F"
exit 0
