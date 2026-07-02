#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
# Exclude 022 (the stock default): asking for the value already in effect would
# make the task trivially satisfied at baseline.
echo "UM=$(rand_choice 027 077 007 037 057)"
