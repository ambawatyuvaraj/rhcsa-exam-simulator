#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "CN=$(rand_choice stoppedcon idlecon parkedcon)"
