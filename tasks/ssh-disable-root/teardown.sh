#!/usr/bin/env bash
rm -f /etc/ssh/sshd_config.d/99-rhcsa-norootlogin.conf 2>/dev/null
systemctl reload sshd >/dev/null 2>&1 || systemctl restart sshd >/dev/null 2>&1 || true
exit 0
