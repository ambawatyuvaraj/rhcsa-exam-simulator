#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "PKG=$(rand_choice tree tcpdump lsof zip unzip wget rsync nmap-ncat bind-utils vim-enhanced)"
