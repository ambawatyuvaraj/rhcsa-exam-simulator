#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "NAME=$(rand_choice heartbeat pulse logtick metric)"
