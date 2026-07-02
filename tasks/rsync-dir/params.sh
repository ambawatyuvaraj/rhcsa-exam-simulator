#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "DEST=$(rand_choice /srv/backup /var/tmp/copy /opt/dest)"
