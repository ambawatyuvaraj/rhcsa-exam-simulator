#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "VG=vg$(rand_int 100 999)"
echo "LV=lv$(rand_int 100 999)"
echo "SNAP=snap$(rand_int 10 99)"
