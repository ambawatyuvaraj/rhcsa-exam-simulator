#!/usr/bin/env bash
dnf -y install chrony >/dev/null 2>&1 || true
# Start from NTP disabled so the candidate must enable it.
timedatectl set-ntp false >/dev/null 2>&1 || true
echo "timedatectl-ntp: NTP sync currently disabled"
exit 0
