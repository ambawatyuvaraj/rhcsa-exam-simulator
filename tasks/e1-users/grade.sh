#!/usr/bin/env bash
# shellcheck source=../../lib/grade-lib.sh
. "$RHCSA_LIB/grade-lib.sh"

# No standalone "group admin exists" checkpoint: the membership checks below
# already imply it. Other tasks' setups (collab dir, sudo) legitimately pre-create
# the admin group, which would otherwise leak baseline points here.
ckpt "harry is in group admin"             4 user_in_group harry admin
ckpt "natasha is in group admin"           4 user_in_group natasha admin
ckpt_expr "sarah has a nologin shell"      3 'getent passwd sarah | grep -qE ":(/usr)?/sbin/nologin$"'
ckpt "harry password is 123"               3 user_password harry 123
ckpt "natasha password is 123"             3 user_password natasha 123
ckpt "sarah password is 123"               3 user_password sarah 123
