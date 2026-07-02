#!/usr/bin/env bash
grep -c -- "$PAT" /etc/passwd > "/root/$OUT"
