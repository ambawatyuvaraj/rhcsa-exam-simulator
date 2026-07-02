#!/usr/bin/env bash
dnf -y install openssh-server >/dev/null 2>&1 || true
echo "ssh-key-target: openssh-server present; candidate creates user deploy + ensures sshd"
exit 0
