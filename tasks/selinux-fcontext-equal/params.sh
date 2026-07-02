#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
n="$(rand_int 100 999)"
echo "SRC=/srv/primary${n}"
echo "DST=/srv/mirror${n}"
