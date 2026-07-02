#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
echo "C=$(rand_choice 'Backup Operator' 'Lab User')"
