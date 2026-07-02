#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice counts.txt tally.txt uniqcount.txt)"
