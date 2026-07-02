#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "chrony.conf has server time.example.com with iburst" 6 'grep -vE "^[[:space:]]*#" /etc/chrony.conf | grep -qE "^(server|pool)[[:space:]]+time\.example\.com\b.*\biburst\b"'
ckpt "chronyd is enabled"                          2 svc_enabled chronyd
ckpt "chronyd is active"                           2 svc_active chronyd
