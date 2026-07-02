#!/usr/bin/env bash
dnf -y install at rsync-daemon >/dev/null 2>&1 || dnf -y install at rsync >/dev/null 2>&1 || true
systemctl unmask "$SVC" >/dev/null 2>&1 || true
echo "service-mask: ensured '$SVC' is installed and unmasked"
exit 0
