#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "root key pair exists" 3 \
  '[ -f /root/.ssh/id_rhcsa ] && [ -f /root/.ssh/id_rhcsa.pub ]'
ckpt_expr "$U authorized_keys contains root's public key" 7 \
  'h=$(getent passwd '"$U"' | cut -d: -f6); grep -qFf /root/.ssh/id_rhcsa.pub "$h/.ssh/authorized_keys" 2>/dev/null'
