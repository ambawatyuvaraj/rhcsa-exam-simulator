#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "GW=$(rand_choice 192.0.2.254 192.0.2.1 192.0.2.126)"
