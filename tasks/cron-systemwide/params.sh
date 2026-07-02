#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "F=$(rand_choice sysjob maintenance heartbeat reporter)"
