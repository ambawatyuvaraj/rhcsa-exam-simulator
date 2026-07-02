#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice os-release.copy osrel.txt remote-osrelease.txt)"
