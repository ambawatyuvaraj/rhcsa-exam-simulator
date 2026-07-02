#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
A=$(rand_choice 200 256 300)
B=$(rand_choice 300 400 500)
echo "A=$A"
echo "B=$B"
echo "E1=$((A + 1))"        # END offset of partition 1; used by the rendered solution
echo "E2=$((A + B + 2))"    # END offset of partition 2
