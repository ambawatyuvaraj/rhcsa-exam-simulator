#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice rootfs.txt fstype.out roottype.txt)"
