#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "F1=$(rand_choice kinfo.txt uname.txt krel.txt)"
echo "F2=$(rand_choice err.log fail.txt stderr.txt)"
