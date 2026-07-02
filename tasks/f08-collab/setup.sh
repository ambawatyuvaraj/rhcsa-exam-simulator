#!/usr/bin/env bash
# The 'manager' group is created by the users-groups task (f08-users). If that task is part
# of THIS session it seeds first and leaves a marker -> do NOT pre-seed the group here (let
# the candidate create it in the users task, so that task starts from a clean slate).
# Standalone (no users task in the session), seed it so this task is solvable on its own.
if [ ! -f /run/rhcsa-sim/f08-users.active ]; then
  groupadd -f manager
fi
rm -rf /home/contrib 2>/dev/null
echo "collaborative-dir: ready"
exit 0
