#!/usr/bin/env bash
# shellcheck source=../../lib/grade-lib.sh
. "$RHCSA_LIB/grade-lib.sh"

# No standalone "group sysmgrs exists" checkpoint: the membership checks below
# already imply it. Other tasks' setups (collab dir, sudo) legitimately pre-create
# the sysmgrs group, which would otherwise leak baseline points here.
ckpt "harry is in group sysmgrs"           4 user_in_group harry sysmgrs
ckpt "natasha is in group sysmgrs"         4 user_in_group natasha sysmgrs
ckpt_expr "sarah has a nologin shell"      3 'getent passwd sarah | grep -qE ":(/usr)?/sbin/nologin$"'
ckpt "harry password is flectrags"         3 user_password harry flectrags
ckpt "natasha password is flectrags"       3 user_password natasha flectrags
ckpt "sarah password is flectrags"         3 user_password sarah flectrags
