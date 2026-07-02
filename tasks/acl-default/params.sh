#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "G=$(rand_group)"
echo "DIR=$(rand_choice acltree inherit-dir teamfiles)"
