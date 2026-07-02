#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "FWSRC=$(rand_choice 10.0.0.0/24 192.168.40.0/24 172.16.5.0/24)"
