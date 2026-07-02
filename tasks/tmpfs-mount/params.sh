#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SZ=$(rand_choice 128 200 256 300)"
echo "MP=$(rand_choice ramdisk scratch memfs)"
