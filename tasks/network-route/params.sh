#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "NET=$(rand_choice 192.168.99.0/24 10.10.20.0/24 172.18.0.0/24)"
echo "GW=$(rand_choice 192.0.2.1 192.0.2.254 192.0.2.100)"
