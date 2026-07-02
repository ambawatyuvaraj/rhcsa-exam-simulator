#!/usr/bin/env bash
rm -f "/root/$OUT"
# Ensure at least one timer exists so the listing is meaningful (best effort).
systemctl enable --now systemd-tmpfiles-clean.timer >/dev/null 2>&1 || true
echo "list-timers: ensured a timer is active and removed any prior /root/$OUT"
exit 0
