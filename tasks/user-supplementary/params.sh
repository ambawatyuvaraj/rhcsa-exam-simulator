#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
g1="$(rand_group)"
g2="$(rand_group)"
while [ "$g2" = "$g1" ]; do g2="$(rand_group)"; done
echo "G1=$g1"
echo "G2=$g2"
