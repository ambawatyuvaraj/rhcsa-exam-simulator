#!/usr/bin/env bash
# Guard: an empty MARK makes `pkill -f ""` match EVERY process (it would kill
# sshd and the whole session). Default MARK and only pkill when it is non-empty.
MARK="${MARK:-rhcsa_killtgt_${RHCSA_TASK_ID:-x}}"
[ -n "$MARK" ] && pkill -f "$MARK" 2>/dev/null
# Start a long-running process whose command line is tagged with $MARK.
bash -c "exec -a $MARK sleep 99999" >/dev/null 2>&1 &
disown 2>/dev/null
echo "kill-process: seeded a long-running '$MARK' process"
exit 0
