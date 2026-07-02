#!/usr/bin/env bash
# 'sysmgrs' is created by the users task. If that task is in THIS session it sets a
# marker -> do NOT pre-seed the group here (let the candidate create it). Standalone,
# seed it so this task is solvable on its own.
[ -f /run/rhcsa-sim/users-groups.active ] || groupadd -f sysmgrs
# Clean slate so the task is NOT already satisfied.
rm -rf /home/managers 2>/dev/null
echo "collaborative-dir: ready"
exit 0
