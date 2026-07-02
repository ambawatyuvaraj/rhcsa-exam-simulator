#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "SELinux is permissive now" 3 \
  'getenforce 2>/dev/null | grep -qx Permissive'
ckpt_expr "config sets SELINUX=permissive" 3 \
  'grep -q "^SELINUX=permissive" /etc/selinux/config'
