#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "logical volume $VG/$LV still exists"   3 lv_exists "$VG" "$LV"
ckpt_expr "$VG is now backed by a single PV" 7 \
  "vgs --noheadings -o pv_count '$VG' 2>/dev/null | tr -d ' ' | grep -qx 1"
