#!/usr/bin/env bash
dnf -y install openssh-server openssh-clients >/dev/null 2>&1 || true
systemctl enable --now sshd >/dev/null 2>&1 || true
rm -f "/root/$OUT"
echo "scp-pull: ensured sshd is running and removed any prior /root/$OUT"
exit 0
