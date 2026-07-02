#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$SVC is masked" 6 '[ "$(systemctl is-enabled '"$SVC"' 2>/dev/null)" = masked ]'
