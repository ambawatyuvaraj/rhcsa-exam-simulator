#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
echo "DIR=$(rand_choice lockedfiles restricted-data closeddir)"
