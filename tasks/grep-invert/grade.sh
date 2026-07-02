#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal grep -v output" 10 \
  'diff <(grep -v -- "$PAT" /opt/invsrc.log) /root/'"$OUT"' >/dev/null 2>&1'
