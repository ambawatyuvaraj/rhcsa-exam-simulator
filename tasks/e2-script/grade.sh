#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/usr/local/bin/newsearch exists and is executable" 4 '[ -x /usr/local/bin/newsearch ]'
ckpt_expr "script finds >30k <50k SETUID files under /usr"     2 'grep -q find /usr/local/bin/newsearch && grep -qE "[+]?30k" /usr/local/bin/newsearch && grep -q "50k" /usr/local/bin/newsearch && grep -qiE "perm|u[+]s|4000" /usr/local/bin/newsearch'
ckpt_expr "output saved to /root/scriptfind matches the search" 4 'diff <(find /usr -size +30k -size -50k -perm /u+s 2>/dev/null | sort) <(sort /root/scriptfind 2>/dev/null) >/dev/null 2>&1'
