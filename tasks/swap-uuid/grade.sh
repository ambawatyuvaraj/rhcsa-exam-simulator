#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "at least 200 MiB of swap is active" 5 swap_total_min 200
ckpt_expr "fstab references the swap by UUID=" 5 \
  "grep -vE '^[[:space:]]*#' /etc/fstab | grep -i swap | grep -q 'UUID='"
