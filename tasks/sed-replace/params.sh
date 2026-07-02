#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OLD=$(rand_choice production staging legacy)"
echo "NEW=$(rand_choice development testing modern)"
echo "OUT=$(rand_choice edited.txt subst.txt result.txt)"
