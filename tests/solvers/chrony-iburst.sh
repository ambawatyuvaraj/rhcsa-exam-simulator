grep -qE "^server[[:space:]]+$SRV[[:space:]]+iburst" /etc/chrony.conf 2>/dev/null \
  || echo "server $SRV iburst" >> /etc/chrony.conf
systemctl enable --now chronyd
