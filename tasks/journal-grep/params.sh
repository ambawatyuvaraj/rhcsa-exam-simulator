#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "STR=$(rand_choice kernel systemd chronyd)"
echo "OUT=$(rand_choice journal-match.txt grep-journal.log matched.txt)"
