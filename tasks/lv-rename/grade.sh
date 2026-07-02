#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "logical volume $VG/$NEW exists"           5 lv_exists "$VG" "$NEW"
ckpt_expr "old name $VG/$OLD no longer exists"   3 "! lvs '$VG/$OLD' >/dev/null 2>&1"
