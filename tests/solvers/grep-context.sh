#!/usr/bin/env bash
grep -A "$N" -- "$PAT" /opt/ctxsrc.log > "/root/$OUT"
