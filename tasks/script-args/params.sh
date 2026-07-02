#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SCRIPT=$(rand_choice greet adder namecat)"
echo "WORD=$(rand_choice hello hi welcome)"
