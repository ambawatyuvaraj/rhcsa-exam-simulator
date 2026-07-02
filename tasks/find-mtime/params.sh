#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "DAYS=$(rand_choice 3 5 7)"
echo "OUT=$(rand_choice recent recentfiles freshfiles)"
