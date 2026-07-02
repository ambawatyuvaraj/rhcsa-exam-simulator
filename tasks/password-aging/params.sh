#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
echo "DAYS=$(rand_choice 30 45 60 90)"
