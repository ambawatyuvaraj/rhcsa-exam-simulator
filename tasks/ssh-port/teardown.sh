#!/usr/bin/env bash
semanage port -d -p tcp "$PORT" 2>/dev/null
rm -f /etc/ssh/sshd_config.d/99-rhcsa-extraport.conf 2>/dev/null
exit 0
