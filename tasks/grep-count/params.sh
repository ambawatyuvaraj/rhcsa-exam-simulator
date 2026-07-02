#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "PAT=$(rand_choice nologin bash root /sbin)"
echo "OUT=$(rand_choice count.txt total.txt n.txt)"
