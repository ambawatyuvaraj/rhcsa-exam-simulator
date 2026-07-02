#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "F=$(rand_choice 1,7 1,3 1,6 3,4)"
echo "OUT=$(rand_choice fields.txt cols.txt extract.txt)"
