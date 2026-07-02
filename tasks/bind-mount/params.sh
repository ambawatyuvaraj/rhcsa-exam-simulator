#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SRC=$(rand_choice projdata appfiles sharedsrc)"
echo "MP=$(rand_choice bindmnt mirror viewdir)"
