grep -qx "$U" /etc/at.deny 2>/dev/null || echo "$U" >> /etc/at.deny
