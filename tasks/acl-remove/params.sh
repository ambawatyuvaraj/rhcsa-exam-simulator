#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "F=$(rand_choice cleanup.dat secret.txt aclold)"
