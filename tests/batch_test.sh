#!/usr/bin/env bash
# Batch-test an exam: seed -> run each task's test-solver -> grade.
# Runs ON THE VM as root.  Usage: batch_test.sh <exam-list-name>
# Requires /opt/rhcsa-sim/tests/solvers/<id>.sh for each task.
set -uo pipefail
EXAM="${1:?usage: batch_test.sh <exam>}"
SIMTASKS=/opt/rhcsa-sim/tasks
SOLVERS=/opt/rhcsa-sim/tests/solvers
PARAMS=/var/lib/rhcsa-sim/params
printf 'CONFIRM\n' | rhcsa-sim start "$EXAM" >/tmp/seed.$EXAM.log 2>&1
grep -iE 'setup failed|could not' /tmp/seed.$EXAM.log && echo "(setup warnings above)"
while read -r t; do
  [ -z "$t" ] && continue
  ( set -a
    [ -f "$PARAMS/$t.env" ] && . "$PARAMS/$t.env"
    [ -f /var/lib/rhcsa-sim/node.conf ] && . /var/lib/rhcsa-sim/node.conf   # PEER_ROLE/PEER_IP for cross-node solvers
    set +a
    export RHCSA_TASK_ID="$t" RHCSA_LIB=/opt/rhcsa-sim/lib RHCSA_ASSETS=/opt/rhcsa-sim/assets RHCSA_STATE=/var/lib/rhcsa-sim
    if [ -f "$SOLVERS/$t.sh" ]; then bash "$SOLVERS/$t.sh"; else echo "NO SOLVER: $t" >&2; fi
  ) </dev/null >>/tmp/solve.$EXAM.log 2>&1
done < <(grep -vE '^\s*#|^\s*$' "/opt/rhcsa-sim/exams/$EXAM.list")
echo "=== grade $EXAM ==="
rhcsa-sim grade 2>&1 | sed 's/\x1b\[[0-9;]*m//g' | grep -E 'FAIL|✗|FINAL SCORE'
