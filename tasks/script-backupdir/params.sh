#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "SCRIPT=$(rand_choice backupdir tarup mkbackup)"
echo "SRCNAME=$(rand_choice bksrc archsrc datadir)"
