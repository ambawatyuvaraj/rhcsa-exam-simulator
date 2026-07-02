#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SCRIPT=$(rand_choice svcctl daemonctl appctl)"
