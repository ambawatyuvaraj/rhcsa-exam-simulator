#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "root has an SSH key pair"             3 \
  '[ -f /root/.ssh/id_ed25519 ] || [ -f /root/.ssh/id_rsa ]'
ckpt_expr "passwordless ssh to deploy@$PEER_ROLE.example.com works" 7 \
  "ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 deploy@$PEER_ROLE.example.com true"
