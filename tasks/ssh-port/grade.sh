#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "ssh_port_t labels TCP port $PORT" 5 \
  "semanage port -l 2>/dev/null | awk '/^ssh_port_t/' | grep -qw $PORT"
ckpt_expr "sshd config adds Port $PORT" 5 \
  "grep -rEq '^[[:space:]]*Port[[:space:]]+$PORT([[:space:]]|\$)' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/ 2>/dev/null"
