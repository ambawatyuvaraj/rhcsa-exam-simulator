#!/usr/bin/env bash
# Seed the user (with its own primary group) and the target group;
# the candidate changes the primary group.
id "$U" >/dev/null 2>&1 || useradd "$U"
groupadd -f "$G"
# Ensure the user's primary group is NOT yet $G so the action is meaningful.
if [ "$(id -gn "$U")" = "$G" ]; then
  groupadd -f "${U}pg" 2>/dev/null
  usermod -g "${U}pg" "$U" >/dev/null 2>&1
fi
echo "user-primary-group: seeded $U and group $G"
exit 0
