#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                  4 user_exists "$U"
ckpt_expr "GECOS comment is '$C'"        4 'getent passwd "$U" | cut -d: -f5 | grep -qF "$C"'
