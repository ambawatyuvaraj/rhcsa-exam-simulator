#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "MODE=$(rand_choice 640 600 750 644)"
echo "TGT=$(rand_choice /root/secret.conf /root/data.bin /root/notes.txt)"
