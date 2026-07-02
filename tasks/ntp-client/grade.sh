#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "chrony.conf has server $PEER_ROLE.example.com with iburst" 7 \
  'grep -vE "^[[:space:]]*#" /etc/chrony.conf | grep -qE "^(server|pool)[[:space:]]+'"$PEER_ROLE"'\.example\.com[[:space:]]+iburst"'
ckpt "chronyd is enabled and active"             3 svc_ok chronyd
