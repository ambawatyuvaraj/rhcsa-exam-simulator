#!/usr/bin/env bash
# Add a static /etc/hosts entry mapping $IP -> $HN (idempotent).
if ! grep -Eq "^$IP[[:space:]]+.*\b$HN\b" /etc/hosts; then
  printf '%s\t%s\n' "$IP" "$HN" >> /etc/hosts
fi
