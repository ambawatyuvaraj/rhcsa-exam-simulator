#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
SZ=$(rand_choice 200 256 300 400)
echo "SZ=$SZ"
echo "END=$((SZ + 10))"   # partition END offset (start 1MiB + ~SZ MiB); used by the rendered solution
