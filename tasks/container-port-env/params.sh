#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "CN=$(rand_choice envrun portsvc cfgcon)"
echo "EV=$(rand_choice APPMODE STAGE TIER)"
echo "VAL=$(rand_choice prod test demo)"
echo "HP=$(rand_choice 8081 8888 9099)"
