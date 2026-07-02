#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "running value of $KEY is $VAL" 4 '[ "$(sysctl -n '"$KEY"' 2>/dev/null)" = "'"$VAL"'" ]'
# Persistence: a config file under /etc must set KEY=VAL (allowing whitespace).
ckpt_expr "$KEY=$VAL is persisted in /etc" 4 \
  'grep -rEqs "^[[:space:]]*'"$KEY"'[[:space:]]*=[[:space:]]*'"$VAL"'[[:space:]]*$" /etc/sysctl.conf /etc/sysctl.d/ 2>/dev/null'
