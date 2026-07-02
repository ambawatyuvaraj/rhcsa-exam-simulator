#!/usr/bin/env bash
dnf -y install chrony >/dev/null 2>&1 || true
echo "ntp-client: chrony present; point it at $PEER_ROLE.example.com"
systemctl disable --now chronyd >/dev/null 2>&1
exit 0
