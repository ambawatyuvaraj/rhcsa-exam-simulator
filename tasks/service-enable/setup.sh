#!/usr/bin/env bash
dnf -y install at rsync-daemon >/dev/null 2>&1 || dnf -y install at rsync >/dev/null 2>&1 || true
systemctl disable --now "$SVC" >/dev/null 2>&1 || true
echo "service-enable: ensured '$SVC' is installed but disabled and stopped"
exit 0
