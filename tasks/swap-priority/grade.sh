#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "a swap area is active with priority $PRI" 5 \
  "swapon --show=NAME,PRIO --noheadings 2>/dev/null | awk '{print \$2}' | grep -qx '$PRI'"
ckpt_expr "fstab swap entry sets pri=$PRI" 5 \
  "grep -vE '^[[:space:]]*#' /etc/fstab | grep -i swap | grep -q 'pri=$PRI'"
