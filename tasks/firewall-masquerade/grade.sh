#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "masquerade enabled (runtime)" 3 \
  'firewall-cmd --query-masquerade 2>/dev/null | grep -qx yes'
ckpt_expr "masquerade enabled (permanent)" 3 \
  'firewall-cmd --permanent --query-masquerade 2>/dev/null | grep -qx yes'
