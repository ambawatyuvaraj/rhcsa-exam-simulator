#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "SELinux is enforcing now" 3 selinux_enforcing
ckpt_expr "config sets SELINUX=enforcing" 3 \
  'grep -q "^SELINUX=enforcing" /etc/selinux/config'
