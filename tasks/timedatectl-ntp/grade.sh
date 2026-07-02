#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "NTP synchronisation is enabled" 8 'timedatectl show -p NTP --value 2>/dev/null | grep -qx yes'
