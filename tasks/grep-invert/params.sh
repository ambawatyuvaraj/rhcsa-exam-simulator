#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "PAT=$(rand_choice ERROR DEBUG WARN)"
echo "OUT=$(rand_choice kept.txt notmatch.txt rest.txt)"
