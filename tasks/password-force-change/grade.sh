#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                              3 user_exists "$U"
# `chage -d 0` / `passwd -e` set the last-change date to 0, which chage reports
# as "password must be changed". Equivalently, shadow field 3 becomes 0.
ckpt_expr "$U must change password at next login"    5 '
  lc=$(getent shadow "$U" | cut -d: -f3);
  [ "$lc" = "0" ] || chage -l "$U" | grep -i "last password change" | grep -qi "must be changed"'
