#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SCRIPT=$(rand_choice sizecheck numtest compare)"
echo "THR=$(rand_int 100 500)"
