#!/usr/bin/env bash
mkdir -p /etc/ssh/sshd_config.d
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/99-rhcsa-norootlogin.conf
systemctl reload sshd 2>/dev/null || systemctl restart sshd 2>/dev/null || true
