#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "FWPORT=$(rand_choice 8080 9090 3000 5000 6443)"
