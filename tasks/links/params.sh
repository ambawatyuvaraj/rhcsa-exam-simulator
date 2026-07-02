#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "HL=$(rand_choice hardlink.txt hl.dat link.hard)"
echo "SL=$(rand_choice symlink.txt sl.dat link.soft)"
