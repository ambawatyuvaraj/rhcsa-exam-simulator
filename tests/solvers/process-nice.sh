#!/usr/bin/env bash
# Start a tagged sleep process at the requested nice value. Idempotent:
# only start one if no matching (comm=sleep, ni=$NICE) tagged process exists.
for pid in $(pgrep -f "$MARK" 2>/dev/null); do
  [ "$(ps -o comm= -p "$pid" 2>/dev/null)" = sleep ] && \
  [ "$(ps -o ni= -p "$pid" 2>/dev/null | tr -d ' ')" = "$NICE" ] && exit 0
done
nice -n "$NICE" bash -c "exec -a $MARK sleep 7000" &
disown 2>/dev/null
