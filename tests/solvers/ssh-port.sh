#!/usr/bin/env bash
semanage port -a -t ssh_port_t -p tcp "$PORT" 2>/dev/null || \
  semanage port -m -t ssh_port_t -p tcp "$PORT"
mkdir -p /etc/ssh/sshd_config.d
{ echo 'Port 22'; echo "Port $PORT"; } > /etc/ssh/sshd_config.d/99-rhcsa-extraport.conf
