#!/usr/bin/env bash
STATE="/var/lib/rhcsa-sim"
PIDF="$STATE/renice.pid"
mkdir -p "$STATE"

# If a previously-seeded process is still alive, reuse it (idempotent).
if [ -f "$PIDF" ]; then
  oldpid="$(cat "$PIDF" 2>/dev/null)"
  if [ -n "$oldpid" ] && [ "$(ps -o comm= -p "$oldpid" 2>/dev/null)" = sleep ]; then
    echo "renice-running: existing '$MARK' process still running (pid $oldpid)"
    exit 0
  fi
fi

# Start a fresh tagged sleep at nice 0.
nice -n 0 bash -c "exec -a $MARK sleep 9000" &
newpid=$!
echo "$newpid" > "$PIDF"
echo "renice-running: started '$MARK' process (pid $newpid) at nice 0"
exit 0
