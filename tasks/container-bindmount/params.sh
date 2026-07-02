#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "CN=$(rand_choice bindrun hostcon bmrun)"
echo "BDIR=/opt/$(rand_choice hostshare appfiles sharedata)"
