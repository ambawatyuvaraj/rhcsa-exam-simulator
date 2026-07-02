#!/usr/bin/env bash
# Solver for ssh-keyauth: generate root's key pair at /root/.ssh/id_rhcsa and
# install the public key into user $U's authorized_keys (context-safe).
set -uo pipefail
: "${U:?U not set}"
id "$U" >/dev/null 2>&1 || useradd "$U"
mkdir -p /root/.ssh && chmod 700 /root/.ssh
[ -f /root/.ssh/id_rhcsa ] || ssh-keygen -t rsa -N '' -f /root/.ssh/id_rhcsa >/dev/null 2>&1

h=$(getent passwd "$U" | cut -d: -f6)
install -d -m 700 -o "$U" -g "$U" "$h/.ssh"
touch "$h/.ssh/authorized_keys"
grep -qFf /root/.ssh/id_rhcsa.pub "$h/.ssh/authorized_keys" 2>/dev/null \
  || cat /root/.ssh/id_rhcsa.pub >> "$h/.ssh/authorized_keys"
chown "$U:$U" "$h/.ssh/authorized_keys"
chmod 600 "$h/.ssh/authorized_keys"
# A raw append leaves the wrong SELinux type; sshd rejects it without this.
restorecon -RF "$h/.ssh" 2>/dev/null || true
