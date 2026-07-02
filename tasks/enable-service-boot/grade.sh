#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "$SVC is enabled at boot"        6 svc_enabled "$SVC"
  ckpt_expr "$SVC is NOT currently active" 4 'svc_enabled "'"$SVC"'" && ! systemctl is-active "'"$SVC"'" >/dev/null 2>&1'
