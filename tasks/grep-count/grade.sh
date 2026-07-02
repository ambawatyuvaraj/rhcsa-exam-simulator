#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "file holds the count of lines matching '$PAT'" 10 \
  '[ "$(tr -d "[:space:]" < /root/'"$OUT"' 2>/dev/null)" = "$(grep -c -- "$PAT" /etc/passwd)" ]'
