#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/usr/local/bin/mysearch exists"              2 path_exists /usr/local/bin/mysearch
ckpt_expr "mysearch is executable"                 2 '[ -x /usr/local/bin/mysearch ]'
ckpt_expr "running mysearch creates /root/setuid.list" 4 'rm -f /root/setuid.list; /usr/local/bin/mysearch >/dev/null 2>&1; [ -s /root/setuid.list ]'
ckpt_expr "results match the required criteria"    6 'diff <(find /usr -size +5k -size -50k -perm -4000 2>/dev/null | sort) <(sort /root/setuid.list 2>/dev/null) >/dev/null 2>&1'
