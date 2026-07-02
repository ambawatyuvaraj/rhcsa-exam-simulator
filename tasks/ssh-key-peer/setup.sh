#!/usr/bin/env bash
dnf -y install openssh-clients >/dev/null 2>&1 || true
mkdir -p /root/.ssh
chmod 700 /root/.ssh
echo "ssh-key-peer: ready to configure passwordless SSH to deploy@$PEER_ROLE.example.com"
exit 0
