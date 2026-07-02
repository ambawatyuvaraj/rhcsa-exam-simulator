#!/usr/bin/env bash
# Seed the user with no expiry; the candidate sets it.
if id "$U" >/dev/null 2>&1; then
  chage -E -1 "$U" >/dev/null 2>&1
else
  useradd "$U"
fi
echo "user-expire-date: seeded $U (no expiry)"
exit 0
