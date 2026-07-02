#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice errors.log priority-err.txt journal-err.txt)"
