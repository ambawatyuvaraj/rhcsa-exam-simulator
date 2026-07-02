#!/usr/bin/env bash
# Seed the user with a normal shell; the candidate changes it.
if id "$U" >/dev/null 2>&1; then
  usermod -s /bin/bash "$U" >/dev/null 2>&1
else
  useradd -s /bin/bash "$U"
fi
echo "user-shell-change: seeded $U with /bin/bash"
exit 0
