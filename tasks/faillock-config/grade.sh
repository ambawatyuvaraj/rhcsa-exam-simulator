#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "faillock.conf sets deny=$N" 6 \
  'grep -qE "^deny[[:space:]]*=[[:space:]]*'"$N"'([[:space:]]*\$|[[:space:]])" /etc/security/faillock.conf'
