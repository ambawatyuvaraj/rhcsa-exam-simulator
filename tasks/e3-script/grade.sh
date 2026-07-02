#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/usr/local/bin/myfind exists"                      2 path_exists /usr/local/bin/myfind
ckpt_expr "myfind is executable"                         2 '[ -x /usr/local/bin/myfind ]'
ckpt_expr "script finds /usr/share files 400k-800k and copies to /root/myfiles" 2 \
  'grep -Eq "find[[:space:]].*/usr/share" /usr/local/bin/myfind && grep -Eq "[-+]?400k" /usr/local/bin/myfind && grep -Eq "[-+]?800k" /usr/local/bin/myfind && grep -Eq "cp" /usr/local/bin/myfind && grep -Eq "/root/myfiles" /usr/local/bin/myfind'
ckpt_expr "after running, /root/myfiles contains the matching files" 4 \
  '[ -d /root/myfiles ] && [ "$(find /root/myfiles -type f 2>/dev/null | wc -l)" -ge 1 ]'
