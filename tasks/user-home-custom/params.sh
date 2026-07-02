#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
u="$(rand_user)"
echo "U=$u"
echo "HOMEDIR=/opt/${u}home"
