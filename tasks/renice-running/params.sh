#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "NICE=$(rand_choice 10 15 19)"
echo "MARK=$(rand_choice reniceproc longjob bgsleep)"
