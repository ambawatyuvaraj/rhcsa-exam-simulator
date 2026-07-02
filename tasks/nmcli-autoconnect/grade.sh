#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "connection rhcsaauto autoconnect disabled" 5 \
  'nmcli -g connection.autoconnect con show rhcsaauto 2>/dev/null | grep -qi no'
