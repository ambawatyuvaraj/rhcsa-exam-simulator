#!/usr/bin/env bash
# No prerequisites to seed — the candidate creates everything.
# Ensure a clean slate so the task is NOT already satisfied and a re-run grades fairly.
for u in harry natasha sarah; do
  id "$u" >/dev/null 2>&1 && userdel -rf "$u" >/dev/null 2>&1
done
getent group sysmgrs >/dev/null 2>&1 && groupdel sysmgrs >/dev/null 2>&1
# Signal sibling tasks (collab/cron) in THIS session that the candidate creates the
# group/users HERE, so they must not pre-seed them (keeps this baseline clean and lets
# `groupadd sysmgrs`/`useradd harry` succeed cleanly).
mkdir -p /run/rhcsa-sim 2>/dev/null && : >/run/rhcsa-sim/users-groups.active 2>/dev/null
echo "users-groups: ready (no seeded prerequisites)"
exit 0
