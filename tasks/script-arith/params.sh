#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SCRIPT=$(rand_choice addnums summer addtwo)"
echo "A=$(rand_int 10 99)"
echo "B=$(rand_int 10 99)"
