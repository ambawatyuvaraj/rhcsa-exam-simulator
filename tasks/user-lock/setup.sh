#!/usr/bin/env bash
# Seed the user with a set (unlocked) password; the candidate locks it.
id "$U" >/dev/null 2>&1 || useradd "$U"
echo 'Redhat123' | passwd --stdin "$U" >/dev/null 2>&1
usermod -U "$U" >/dev/null 2>&1
echo "user-lock: seeded $U (unlocked, password set)"
exit 0
