#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "DNS1=$(rand_choice 192.168.10.1 10.0.0.53 172.16.0.1)"
echo "DNS2=$(rand_choice 8.8.4.4 1.0.0.1 9.9.9.9)"
