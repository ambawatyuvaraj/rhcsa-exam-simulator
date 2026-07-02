grep -qx "$U" /etc/cron.deny 2>/dev/null || echo "$U" >> /etc/cron.deny
