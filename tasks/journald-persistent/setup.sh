#!/usr/bin/env bash
rm -rf /var/log/journal 2>/dev/null
sed -i 's/^#\?Storage=.*/#Storage=auto/' /etc/systemd/journald.conf 2>/dev/null
systemctl restart systemd-journald 2>/dev/null
echo "journald-persistent: reset journal storage to non-persistent default"
exit 0
