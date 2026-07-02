#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "contents equal grep -E output" 10 'diff <(grep -E "$PAT" /etc/passwd) /root/'"$OUTF"' >/dev/null 2>&1'
