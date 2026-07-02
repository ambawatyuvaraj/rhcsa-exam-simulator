#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
n="$(rand_int 100 999)"
echo "F=page${n}.html"
echo "F2=copy${n}.html"
