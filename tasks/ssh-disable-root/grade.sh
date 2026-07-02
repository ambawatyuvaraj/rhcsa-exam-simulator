#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "effective sshd config denies root login" 8 \
  'sshd -T 2>/dev/null | grep -qi "^permitrootlogin no"'
