#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "volume group $VG exists" 4 "vgs '$VG' >/dev/null 2>&1"
ckpt "physical-extent size of $VG is $PE MiB" 6 vg_extent_size "$VG" "$PE"
