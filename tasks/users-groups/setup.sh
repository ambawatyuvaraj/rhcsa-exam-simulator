#!/usr/bin/env bash
# No prerequisites to seed — the candidate creates everything.
# Ensure a clean slate so a re-run grades fairly.
for u in natasha harry sarah; do
  id "$u" >/dev/null 2>&1 && userdel -rf "$u" >/dev/null 2>&1
done
getent group sysmgrs >/dev/null 2>&1 && groupdel sysmgrs >/dev/null 2>&1
# Signal a sibling collaborative-dir task in THIS session that the candidate creates the
# 'sysmgrs' group HERE, so it must not pre-seed it (keeps this baseline clean).
mkdir -p /run/rhcsa-sim 2>/dev/null && : >/run/rhcsa-sim/users-groups.active 2>/dev/null
echo "users-groups: ready (no seeded prerequisites)"
exit 0
