#!/usr/bin/env bash
# Seed the user and the two target groups; the candidate adds the memberships.
id "$U" >/dev/null 2>&1 || useradd "$U"
groupadd -f "$G1"
groupadd -f "$G2"
# Ensure clean slate so a re-run grades fairly (remove only the two target groups
# from the user's membership; recreate group, leaving primary group intact).
gpasswd -d "$U" "$G1" >/dev/null 2>&1
gpasswd -d "$U" "$G2" >/dev/null 2>&1
echo "user-supplementary: seeded $U, groups $G1 and $G2"
exit 0
