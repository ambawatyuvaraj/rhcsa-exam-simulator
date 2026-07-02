#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/usr/local/bin/mysearch exists"                    2 path_exists /usr/local/bin/mysearch
ckpt_expr "mysearch is executable"                       2 '[ -x /usr/local/bin/mysearch ]'
ckpt_expr "script finds files under /usr/share <1M and copies to /root/myfiles" 2 'grep -Eq "find[[:space:]].*/usr/share" /usr/local/bin/mysearch && grep -Eq "size[[:space:]]*-1M" /usr/local/bin/mysearch && grep -Eq "cp" /usr/local/bin/mysearch && grep -Eq "/root/myfiles" /usr/local/bin/mysearch'
ckpt_expr "after running, /root/myfiles contains files"  4 '[ -d /root/myfiles ] && [ "$(find /root/myfiles -type f 2>/dev/null | wc -l)" -ge 1 ]'
