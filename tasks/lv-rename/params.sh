#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "VG=vg$(rand_int 100 999)"
echo "OLD=oldlv$(rand_int 10 99)"
echo "NEW=newlv$(rand_int 10 99)"
