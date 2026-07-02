#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "OUT=$(rand_choice timers.txt timer-list.txt systemd-timers.log)"
