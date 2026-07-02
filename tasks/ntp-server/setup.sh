#!/usr/bin/env bash
dnf -y install chrony >/dev/null 2>&1 || true
echo "ntp-server: chrony present (not yet configured to serve)"
systemctl disable --now chronyd >/dev/null 2>&1
exit 0
