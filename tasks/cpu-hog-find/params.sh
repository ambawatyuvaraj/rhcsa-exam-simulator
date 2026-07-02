#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice topcpu.txt cpu-hog.txt busiest.txt)"
