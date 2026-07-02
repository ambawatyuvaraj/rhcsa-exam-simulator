#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
echo "MIN=$(rand_choice 2 5 7)"
