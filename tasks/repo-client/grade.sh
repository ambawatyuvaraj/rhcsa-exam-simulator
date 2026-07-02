#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "peerrepo is enabled in dnf"           5 \
  'dnf -q repolist enabled 2>/dev/null | awk "{print \$1}" | grep -qx peerrepo'
ckpt_expr "peerrepo baseurl points to the peer HTTP repo" 3 \
  'grep -rhA10 "^\[peerrepo\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -qE "baseurl[[:space:]]*=[[:space:]]*http://(node1\.example\.com|'"$PEER_ROLE"'\.example\.com)/pkgrepo"'
ckpt_expr "gpgcheck disabled for peerrepo"       2 \
  'grep -rhA10 "^\[peerrepo\]" /etc/yum.repos.d/*.repo 2>/dev/null | grep -qiE "gpgcheck[[:space:]]*=[[:space:]]*0"'
