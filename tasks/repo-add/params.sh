#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "RID=$(rand_choice extras local-tools custom-repo)"
echo "DIR=$(rand_choice /opt/extrarepo /opt/customrepo)"
