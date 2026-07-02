#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
MP=$(rand_choice data1 store extra)
SZ=$(rand_choice 256 300 400 512)
echo "MP=$MP"
echo "SZ=$SZ"
echo "END=$((SZ + 1))"   # partition END offset (start 1MiB + ~SZ MiB); used by the rendered solution
