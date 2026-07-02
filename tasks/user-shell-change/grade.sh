#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                  3 user_exists "$U"
ckpt "$U login shell is $SH"             5 user_shell "$U" "$SH"
