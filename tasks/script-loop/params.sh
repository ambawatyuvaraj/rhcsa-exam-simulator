#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SCRIPT=$(rand_choice makefiles genfiles createset)"
echo "N=$(rand_int 5 12)"
echo "DIR=$(rand_choice /root/loopout /root/batch /root/series)"
