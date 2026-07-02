#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
echo "DATE=$(rand_choice 2030-12-31 2028-06-30)"
