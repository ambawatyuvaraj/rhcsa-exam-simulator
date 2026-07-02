#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice sorted.txt numsorted.txt ordered.txt)"
