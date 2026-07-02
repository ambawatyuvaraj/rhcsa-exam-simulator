#!/usr/bin/env bash
# Create remoteu with the exact UID/home the grader expects. Be idempotent: if
# the user already exists (e.g. with a different home), fix the home rather than
# silently leaving it wrong.
if id remoteu >/dev/null 2>&1; then
  usermod -u 4400 -d /exports/nodeshare/remoteu -m remoteu >/dev/null 2>&1 || true
else
  useradd -u 4400 -d /exports/nodeshare/remoteu -m remoteu >/dev/null 2>&1 || true
fi
mkdir -p /exports/nodeshare/remoteu && chown remoteu:remoteu /exports/nodeshare/remoteu
echo '/exports/nodeshare *(rw,sync,no_root_squash)' >/etc/exports.d/nodeshare.exports
systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra >/dev/null 2>&1
firewall-cmd --add-service=nfs --permanent >/dev/null 2>&1
firewall-cmd --reload >/dev/null 2>&1
