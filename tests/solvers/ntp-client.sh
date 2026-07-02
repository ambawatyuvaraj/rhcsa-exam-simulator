#!/usr/bin/env bash
grep -qE "^server[[:space:]]+$PEER_ROLE\.example\.com[[:space:]]+iburst" /etc/chrony.conf \
  || echo "server $PEER_ROLE.example.com iburst" >>/etc/chrony.conf
systemctl enable --now chronyd >/dev/null 2>&1
