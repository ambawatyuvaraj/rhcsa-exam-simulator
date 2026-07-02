#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "volume group $VG now contains two physical volumes" 8 \
  "vgs --noheadings -o pv_count '$VG' 2>/dev/null | tr -d ' ' | grep -qx 2"
