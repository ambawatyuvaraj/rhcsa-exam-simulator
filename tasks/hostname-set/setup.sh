#!/usr/bin/env bash
# Ensure the current static hostname differs from the target.
cur="$(hostnamectl --static 2>/dev/null)"
if [ "$cur" = "$HN" ]; then
  hostnamectl set-hostname localhost.localdomain >/dev/null 2>&1 || true
fi
echo "hostname-set: current static hostname is '$(hostnamectl --static 2>/dev/null)' (target '$HN')"
exit 0
