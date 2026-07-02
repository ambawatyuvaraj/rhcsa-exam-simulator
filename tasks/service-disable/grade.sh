#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$SVC is not enabled at boot" 4 '! systemctl is-enabled '"$SVC"' >/dev/null 2>&1'
ckpt_expr "$SVC is not active" 4 '! systemctl is-active '"$SVC"' >/dev/null 2>&1'
