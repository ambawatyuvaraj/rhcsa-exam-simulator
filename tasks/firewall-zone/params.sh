#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "ZONE=$(rand_choice work home dmz internal)"
