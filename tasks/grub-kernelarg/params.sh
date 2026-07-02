#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "ARG=$(rand_choice audit=0 quiet transparent_hugepage=never)"
