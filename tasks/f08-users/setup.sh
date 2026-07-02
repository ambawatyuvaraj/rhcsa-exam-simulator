#!/usr/bin/env bash
# No prerequisites to seed — the candidate creates everything.
# Ensure a clean slate so a re-run grades fairly.
for u in natasha harry sarah; do
  id "$u" >/dev/null 2>&1 && userdel -rf "$u" >/dev/null 2>&1
done
getent group manager >/dev/null 2>&1 && groupdel manager >/dev/null 2>&1
# Signal a sibling collaborative-dir task (f08-collab) in THIS session that the candidate
# creates the 'manager' group HERE, so it must not pre-seed it (keeps this baseline clean).
mkdir -p /run/rhcsa-sim 2>/dev/null && : >/run/rhcsa-sim/f08-users.active 2>/dev/null
echo "users-groups: ready (no seeded prerequisites)"
exit 0
