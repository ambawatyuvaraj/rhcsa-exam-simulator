#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUTF=$(rand_choice chrony.log timesync.txt unitlog.txt)"
