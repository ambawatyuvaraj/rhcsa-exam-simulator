#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
A=$(rand_choice 10 20 30 40)
echo "A=$A"
echo "B=$(( A + $(rand_choice 5 9 14) ))"
echo "OUT=$(rand_choice range.txt lines.txt slice.txt)"
