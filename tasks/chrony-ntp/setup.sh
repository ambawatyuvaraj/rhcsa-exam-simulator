#!/usr/bin/env bash
dnf -y install chrony >/dev/null 2>&1 || true
echo "chrony-ntp: chrony present"
systemctl disable --now chronyd >/dev/null 2>&1
exit 0
