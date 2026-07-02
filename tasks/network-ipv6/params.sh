#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "IP6=$(rand_choice 2001:db8:1::10 fd00:abcd::20 2001:db8:cafe::30)"
