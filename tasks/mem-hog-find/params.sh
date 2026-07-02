#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice topmem.txt mem-hog.txt biggest.txt)"
