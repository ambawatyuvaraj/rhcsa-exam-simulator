#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                        3 user_exists "$U"
# Compare the expiry day-count in /etc/shadow (field 8) to the target date,
# independent of locale/date formatting in `chage -l`.
ckpt_expr "account $U expires on $DATE"        5 '
  want=$(date -u -d "$DATE" +%s 2>/dev/null);
  want=$(( want / 86400 ));
  got=$(getent shadow "$U" | cut -d: -f8);
  [ -n "$got" ] && [ "$got" = "$want" ]'
