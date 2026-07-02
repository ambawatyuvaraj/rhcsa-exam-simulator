#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "IP=$(rand_choice 10.20.30.40 192.168.50.60 172.16.80.90)"
