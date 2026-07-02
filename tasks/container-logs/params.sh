#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "CN=$(rand_choice logcon emitcon noisycon)"
echo "OUT=$(rand_choice containerlogs.txt applog.txt logs.out)"
