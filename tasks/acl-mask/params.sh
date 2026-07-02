#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "F=$(rand_choice maskfile.dat report.txt acltarget)"
