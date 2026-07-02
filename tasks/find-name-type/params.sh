#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "EXT=$(rand_choice conf log txt)"
echo "OUT=$(rand_choice namelist.txt matches.txt files.txt)"
