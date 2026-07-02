#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "LBL=$(rand_choice swapfs extraswap myswap swapvol)"
