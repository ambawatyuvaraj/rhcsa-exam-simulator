#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "CN=$(rand_choice volrun voldata appvolrun)"
echo "VOL=$(rand_choice appvol datavol)"
