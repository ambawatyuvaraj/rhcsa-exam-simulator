#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "pam_wheel.so is enabled in /etc/pam.d/su" 8 \
  'grep -vE "^[[:space:]]*#" /etc/pam.d/su 2>/dev/null | grep -qE "^[[:space:]]*auth[[:space:]]+(required|sufficient)[[:space:]]+pam_wheel\.so"'
