#!/usr/bin/env bash
# Install the package that PROVIDES the unit — the service name differs from the
# package name (atd←at; rsyncd←rsync-daemon on RHEL 9, where rsync was split).
dnf -y install at rsync-daemon >/dev/null 2>&1 || dnf -y install at rsync >/dev/null 2>&1 || true
# Start from a known state: disabled and stopped (candidate must enable only).
systemctl disable "$SVC" >/dev/null 2>&1 || true
systemctl stop "$SVC" >/dev/null 2>&1 || true
echo "enable-service-boot: '$SVC' installed, disabled and stopped"
exit 0
