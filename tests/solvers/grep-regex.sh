#!/usr/bin/env bash
# Write grep -E matches from /etc/passwd to /root/$OUTF (idempotent).
grep -E "$PAT" /etc/passwd > "/root/$OUTF"
