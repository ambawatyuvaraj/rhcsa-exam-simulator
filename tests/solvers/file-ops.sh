#!/usr/bin/env bash
# Create directory tree, an empty file, and copy /etc/hostname (idempotent).
mkdir -p "$BASE/$SUB"
touch "$BASE/$SUB/keep.txt"
cp -f /etc/hostname "$BASE/host.copy"
