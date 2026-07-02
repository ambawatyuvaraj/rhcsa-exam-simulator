#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "BASE=$(rand_choice /root/project /root/work /root/lab)"
echo "SUB=$(rand_choice data conf logs)"
