#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "PAT=$(rand_choice ERROR START COMMIT)"
echo "N=$(rand_choice 1 2 3)"
echo "OUT=$(rand_choice context.txt afterlines.txt block.txt)"
