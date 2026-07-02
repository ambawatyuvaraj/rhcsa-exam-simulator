#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
# A realistic exam-style target password, randomised per run so the answer
# can't be memorised (the real paper prints one fixed value, e.g. 'redhat').
echo "PW=$(rand_choice redhat trootent postroll flectrag atenorth redhat123)"
