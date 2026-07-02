#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "datasrc/file1 present on the peer under /home/deploy" 8 \
  "ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=6 deploy@$PEER_ROLE.example.com 'test -f /home/deploy/datasrc/file1'"
