#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "F=$(rand_choice atdone.txt scheduled.txt later.txt)"
