#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$HL is a hard link to linksrc.txt" 5 '[ /root/'"$HL"' -ef /root/linksrc.txt ] && [ "$(stat -c %h /root/linksrc.txt)" -ge 2 ]'
ckpt_expr "$SL is a symlink to linksrc.txt" 5 '[ -L /root/'"$SL"' ] && [ "$(readlink -f /root/'"$SL"')" = /root/linksrc.txt ]'
