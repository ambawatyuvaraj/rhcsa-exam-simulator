#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "ARC=$(rand_choice payload backup bundle)"
echo "DEST=$(rand_choice /root/extracted /root/unpacked /root/out)"
