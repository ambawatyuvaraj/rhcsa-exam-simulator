#!/usr/bin/env bash
# Ensure a clean slate (don't create the units — that's the candidate's job).
systemctl disable --now "$NAME.timer" >/dev/null 2>&1 || true
rm -f "/etc/systemd/system/$NAME.timer" "/etc/systemd/system/$NAME.service" 2>/dev/null
systemctl daemon-reload >/dev/null 2>&1 || true
echo "systemd-timer: cleared any prior $NAME units"
exit 0
