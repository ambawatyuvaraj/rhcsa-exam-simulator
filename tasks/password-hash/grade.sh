#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "password of $U matches the required value" 6 user_password "$U" "$PW"
