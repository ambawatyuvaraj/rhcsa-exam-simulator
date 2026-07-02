#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "max password age for $U is $DAYS" 8 user_pw_maxdays "$U" "$DAYS"
