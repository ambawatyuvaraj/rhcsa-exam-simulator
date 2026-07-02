#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/$DIR is a directory" 2 is_dir "/$DIR"
ckpt_expr "/$DIR has mode 1777 (sticky, world-writable)" 4 \
  '[ "$(stat -c %a /'"$DIR"')" = 1777 ]'
