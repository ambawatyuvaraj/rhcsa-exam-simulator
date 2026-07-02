#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "FWSVC=$(rand_choice http https ftp nfs samba)"
