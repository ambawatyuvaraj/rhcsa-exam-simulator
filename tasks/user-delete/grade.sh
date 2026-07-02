#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "user $U no longer exists"        5 '! id "$U" >/dev/null 2>&1'
ckpt_expr "home /home/$U is removed"        3 '! [ -d "/home/$U" ]'
