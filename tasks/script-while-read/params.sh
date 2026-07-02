#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SCRIPT=$(rand_choice linecount countlines numlines)"
echo "K=$(rand_int 5 40)"
