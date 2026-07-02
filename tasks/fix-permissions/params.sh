#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "TGT=$(rand_choice /opt/report.dat /srv/data.txt /opt/shared.conf)"
echo "MODE=$(rand_choice 644 640 664)"
