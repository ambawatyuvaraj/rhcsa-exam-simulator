#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"                      2 user_exists "$U"
ckpt_expr "minimum password age is $MIN"     4 '[ "$(chage -l "$U" | awk -F: "/Minimum/{gsub(/ /,\"\",\$2);print \$2}")" = "$MIN" ]'
ckpt_expr "warning period is 10"             2 '[ "$(chage -l "$U" | awk -F: "/warning/{gsub(/ /,\"\",\$2);print \$2}")" = "10" ]'
