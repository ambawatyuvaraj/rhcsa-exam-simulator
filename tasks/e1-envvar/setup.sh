#!/usr/bin/env bash
# alies is created by the UID task; defer to it when present (marker), else create here
# so this task is solvable standalone. Do NOT pin UID 1326 here (the UID task owns that).
[ -f /run/rhcsa-sim/user-uid.active ] || { id alies >/dev/null 2>&1 || useradd alies; }
# Clean baseline: strip any existing RHCSA assignment/export from alies's login
# profile so the variable is NOT already set before the candidate works.
f=/home/alies/.bash_profile
if [ -f "$f" ]; then
  sed -i -E '/^[[:space:]]*(export[[:space:]]+)?RHCSA([[:space:]]*=.*)?$/d' "$f" 2>/dev/null
fi
echo "envvar: seeded alies (RHCSA unset)"
exit 0
