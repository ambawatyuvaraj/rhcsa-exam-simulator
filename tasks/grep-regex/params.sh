#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "PAT=$(rand_choice '^root' 'bash$' 'nologin' '/sbin')"
echo "OUTF=$(rand_choice match.txt found.txt lines.txt)"
