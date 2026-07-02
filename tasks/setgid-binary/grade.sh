#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "SGID bit set on /usr/local/bin/$B" 6 \
  'stat -c %A /usr/local/bin/'"$B"' 2>/dev/null | cut -c7 | grep -qi s && [ "$(stat -c %a /usr/local/bin/'"$B"' 2>/dev/null | sed -E "s/^0*//")" -ge 2000 ]'
