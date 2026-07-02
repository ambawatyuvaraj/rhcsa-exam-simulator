#!/usr/bin/env bash
# Seed the user with default aging; the candidate adjusts it.
if id "$U" >/dev/null 2>&1; then
  chage -m 0 -W 7 "$U" >/dev/null 2>&1
else
  useradd "$U"
fi
echo "password-minage: seeded $U"
exit 0
