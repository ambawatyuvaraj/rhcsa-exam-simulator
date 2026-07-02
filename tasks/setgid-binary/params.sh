#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "B=$(rand_choice maint report backup audit)tool$(rand_int 10 99)"
