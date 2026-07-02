#!/usr/bin/env bash
# Seed the user with a valid (non-expired) password; the candidate expires it.
id "$U" >/dev/null 2>&1 || useradd "$U"
echo 'Redhat123' | passwd --stdin "$U" >/dev/null 2>&1
chage -d "$(date +%Y-%m-%d)" "$U" >/dev/null 2>&1
echo "password-force-change: seeded $U (password valid)"
exit 0
