#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                  2 user_exists "$U"
ckpt "Group '$G' exists"                 2 group_exists "$G"
ckpt_expr "$U primary group is $G"       4 '[ "$(id -gn "$U")" = "$G" ]'
