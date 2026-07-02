#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SRV=$(rand_choice ntp1.example.com time.google.com 0.pool.ntp.org)"
