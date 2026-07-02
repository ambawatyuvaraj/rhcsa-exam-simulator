#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "U=$(rand_user)"
echo "SH=$(rand_choice /sbin/nologin /usr/bin/sh)"
