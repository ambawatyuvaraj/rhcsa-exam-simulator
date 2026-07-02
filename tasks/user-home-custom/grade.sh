#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                       3 user_exists "$U"
ckpt_expr "$U home directory is $HOMEDIR"     3 '[ "$(getent passwd "$U" | cut -d: -f6)" = "$HOMEDIR" ]'
ckpt "home directory $HOMEDIR exists"         2 is_dir "$HOMEDIR"
