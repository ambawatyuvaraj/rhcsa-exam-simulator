#!/usr/bin/env bash
UNIT="rhcsa-failunit.service"
systemctl reset-failed "$UNIT" >/dev/null 2>&1
rm -f "/etc/systemd/system/$UNIT"
systemctl daemon-reload >/dev/null 2>&1
rm -f "/root/$OUT"
exit 0
