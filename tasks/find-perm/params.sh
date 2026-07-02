#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "MODE=$(rand_choice 644 600 755)"
echo "OUT=$(rand_choice permmatch permfiles modematch)"
