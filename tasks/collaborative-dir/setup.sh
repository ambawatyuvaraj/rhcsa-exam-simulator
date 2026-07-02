#!/usr/bin/env bash
# 'sysmgrs' is created by the users-groups task. If that task is part of THIS session it
# seeds first and leaves a marker -> do NOT pre-seed the group here (let the candidate
# create it in the users task). Standalone, seed it so this task is solvable on its own.
if [ ! -f /run/rhcsa-sim/users-groups.active ]; then
  groupadd -f sysmgrs
fi
rm -rf /home/managers 2>/dev/null
echo "collaborative-dir: ready"
exit 0
