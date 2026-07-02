#!/usr/bin/env bash
PIDF="/var/lib/rhcsa-sim/renice.pid"
pid="$(cat "$PIDF" 2>/dev/null)"
if [ -n "$pid" ] && [ "$(ps -o comm= -p "$pid" 2>/dev/null)" = sleep ]; then
  kill "$pid" 2>/dev/null
fi
rm -f "$PIDF"
exit 0
