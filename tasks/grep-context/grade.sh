#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal grep -A $N output" 10 \
  'diff <(grep -A '"$N"' -- "$PAT" /opt/ctxsrc.log) /root/'"$OUT"' >/dev/null 2>&1'
