#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "umask for $U is 0$UM" 8 \
  'runuser -l '"$U"' -c umask 2>/dev/null | tr -d "[:space:]" | grep -qx "0'"$UM"'"'
