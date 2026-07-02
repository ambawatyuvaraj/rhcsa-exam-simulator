#!/usr/bin/env bash
# shellcheck source=../../lib/grade-lib.sh
. "$RHCSA_LIB/grade-lib.sh"

ckpt "Group 'manager' exists"                  3 group_exists manager
ckpt "User 'natasha' exists"                   2 user_exists natasha
ckpt "natasha is in group manager"             2 user_in_group natasha manager
ckpt "User 'harry' exists"                     2 user_exists harry
ckpt "harry is in group manager"               2 user_in_group harry manager
ckpt "User 'sarah' exists"                     2 user_exists sarah
ckpt_expr "sarah has a nologin shell"          2 'getent passwd sarah | grep -qE ":(/usr)?/sbin/nologin$"'
  ckpt_expr "sarah is NOT in manager"            1 'id sarah >/dev/null 2>&1 && ! id -nG sarah 2>/dev/null | tr " " "\n" | grep -qx manager'
ckpt "natasha password is correct"             2 user_password natasha ratencot
ckpt "harry password is correct"               1 user_password harry ratencot
ckpt "sarah password is correct"               1 user_password sarah ratencot
