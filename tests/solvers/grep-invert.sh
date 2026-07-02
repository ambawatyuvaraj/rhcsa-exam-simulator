#!/usr/bin/env bash
grep -v -- "$PAT" /opt/invsrc.log > "/root/$OUT"
