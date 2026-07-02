#!/usr/bin/env bash
rm -rf /opt/datasrc 2>/dev/null
ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 \
  "deploy@$PEER_ROLE.example.com" 'rm -rf /home/deploy/datasrc' >/dev/null 2>&1 || true
exit 0
