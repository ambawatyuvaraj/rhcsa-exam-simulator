#!/usr/bin/env bash
rm -f /etc/ssh/sshd_config.d/99-rhcsa-norootlogin.conf 2>/dev/null
echo "ssh-disable-root: ready"
exit 0
