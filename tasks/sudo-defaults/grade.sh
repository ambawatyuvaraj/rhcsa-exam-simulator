#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "sudoers sets timestamp_timeout=$T" 5 \
  "grep -rhEq '^[[:space:]]*Defaults.*timestamp_timeout[[:space:]]*=[[:space:]]*$T([[:space:]]|,|\$)' /etc/sudoers /etc/sudoers.d/ 2>/dev/null"
ckpt_expr "sudoers configuration is valid" 3 \
  'visudo -c >/dev/null 2>&1'
