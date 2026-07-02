#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# The persisted active profile (survives reboot) must equal the target.
ckpt_expr "active tuned profile is $PROF" 6 \
  'cur="$(cat /etc/tuned/active_profile 2>/dev/null)"; [ -z "$cur" ] && cur="$(tuned-adm active 2>/dev/null | sed "s/.*: //")"; [ "$cur" = "'"$PROF"'" ]'
