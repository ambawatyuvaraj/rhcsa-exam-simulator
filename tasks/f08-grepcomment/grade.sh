#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/list exists"                                 2 path_exists /root/list
ckpt_expr "equals the uncommented lines of /etc/sudoers" 8 'diff <(grep -v "^#" /etc/sudoers) /root/list >/dev/null 2>&1 && [ -s /root/list ]'
