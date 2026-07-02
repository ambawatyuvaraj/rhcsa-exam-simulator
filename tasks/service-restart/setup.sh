#!/usr/bin/env bash
SVC="${SVC:-chronyd}"
dnf -y install chrony >/dev/null 2>&1 || true
systemctl unmask "$SVC" >/dev/null 2>&1 || true
# Stop it (leave it ENABLED) so the candidate must actually (re)start it — otherwise the
# vendor-preset-enabled+running baseline would pass the grade with zero work.
systemctl stop "$SVC" >/dev/null 2>&1 || true
echo "service-restart: '$SVC' installed and stopped (candidate must start/restart it)"
exit 0
