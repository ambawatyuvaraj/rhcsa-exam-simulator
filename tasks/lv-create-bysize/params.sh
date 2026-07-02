#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "VG=vg$(rand_int 100 999)"
echo "LV=lv$(rand_int 100 999)"
echo "MP=$(rand_choice data1 store extra appdata)"
echo "SZ=$(rand_choice 200 300 400)"
