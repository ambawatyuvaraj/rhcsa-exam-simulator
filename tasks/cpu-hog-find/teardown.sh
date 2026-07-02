#!/usr/bin/env bash
# Kill every cpuhog busy loop (not just the last one recorded), so no stray
# loop is left pegging a CPU core after the task.
pkill -9 -f 'cpuhog -c' 2>/dev/null
rm -f /var/lib/rhcsa-sim/cpuhog.pid "/root/$OUT"
exit 0
