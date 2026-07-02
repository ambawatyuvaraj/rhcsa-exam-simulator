#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "snapshot $VG/$SNAP exists"             4 lv_exists "$VG" "$SNAP"
ckpt_expr "snapshot origin is $LV"           4 \
  "lvs --noheadings -o origin '$VG/$SNAP' 2>/dev/null | grep -qw '$LV'"
