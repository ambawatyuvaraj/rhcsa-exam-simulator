#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "CN=$(rand_choice execcon runcon livecon)"
echo "OUT=$(rand_choice osrelease.txt containeros.txt execout.txt)"
