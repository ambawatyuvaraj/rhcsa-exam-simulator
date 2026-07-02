#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user '$U' exists"                       2 user_exists "$U"
ckpt_expr "'$U' listed in /etc/at.deny"       6 'grep -qx "'"$U"'" /etc/at.deny'
