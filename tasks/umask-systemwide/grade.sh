#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Accept either a profile.d / profile umask line, or a UMASK in login.defs.
ckpt_expr "system-wide default umask is $UM" 8 '
  grep -rqsE "umask[[:space:]]+0?$UM\b" /etc/profile.d/ /etc/profile 2>/dev/null \
  || grep -qiE "^[[:space:]]*UMASK[[:space:]]+0?$UM\b" /etc/login.defs 2>/dev/null'
