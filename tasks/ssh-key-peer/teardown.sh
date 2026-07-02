#!/usr/bin/env bash
# Best-effort: remove root's pubkey from deploy's authorized_keys on the peer.
if [ -f /root/.ssh/id_ed25519.pub ]; then
  key="$(cut -d' ' -f2 /root/.ssh/id_ed25519.pub 2>/dev/null)"
  if [ -n "$key" ]; then
    ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 \
      "deploy@$PEER_ROLE.example.com" \
      "sed -i '\#$key#d' ~/.ssh/authorized_keys 2>/dev/null" >/dev/null 2>&1 || true
  fi
fi
exit 0
