#!/usr/bin/env bash
systemctl disable --now "$NAME.timer" >/dev/null 2>&1 || true
rm -f "/etc/systemd/system/$NAME.timer" "/etc/systemd/system/$NAME.service" 2>/dev/null
systemctl daemon-reload >/dev/null 2>&1 || true
exit 0
