#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "RHCSA env var is set for alies" 8 \
  'runuser -l alies -c "echo \$RHCSA" 2>/dev/null | grep -qx "Welcome to Advantage Pro"'
