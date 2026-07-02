#!/usr/bin/env bash
dnf -y install at rsync-daemon >/dev/null 2>&1 || dnf -y install at rsync >/dev/null 2>&1 || true
systemctl unmask "$SVC" >/dev/null 2>&1 || true
systemctl enable --now "$SVC" >/dev/null 2>&1 || true
echo "service-disable: ensured '$SVC' is installed, enabled and running"
exit 0
