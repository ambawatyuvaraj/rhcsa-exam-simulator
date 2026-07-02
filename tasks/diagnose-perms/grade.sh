#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "ownership of /$DIR is still root" 3 \
  '[ "$(stat -c %U /'"$DIR"')" = root ]'
ckpt_expr "$U can list and read /$DIR/file" 5 \
  'runuser -l '"$U"' -c "cat /'"$DIR"'/file" >/dev/null 2>&1'
