#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/lines.txt exists"                      2 path_exists /root/lines.txt
ckpt_expr "contents exactly match grep output"     6 'diff <(grep strato /usr/share/rhcsa/wordlist) /root/lines.txt >/dev/null 2>&1'
  ckpt_expr "no blank lines present"                 2 '[ -s /root/lines.txt ] && ! grep -qx "" /root/lines.txt'
