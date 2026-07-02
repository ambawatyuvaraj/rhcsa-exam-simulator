#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "LBL=$(rand_choice mydata appfs storg)"
echo "MP=$(rand_choice lbldata lblmnt)"
