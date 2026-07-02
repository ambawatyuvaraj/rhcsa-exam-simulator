#!/usr/bin/env bash
mkdir -p /var/www/html
echo "<h1>source</h1>" > "/var/www/html/$F"
restorecon /var/www/html/"$F" 2>/dev/null
rm -f "/var/www/html/$F2"
echo "selinux-context-copy: seeded /var/www/html/$F"
exit 0
