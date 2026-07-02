#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "PASS_MAX_DAYS is 20 in /etc/login.defs" 8 \
  'grep -qE "^[[:space:]]*PASS_MAX_DAYS[[:space:]]+20\b" /etc/login.defs'
