#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "PNAME=$(rand_choice datapart srvdata backupvol appvol)"
