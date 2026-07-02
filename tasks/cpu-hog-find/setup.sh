#!/usr/bin/env bash
STATE="/var/lib/rhcsa-sim"
PIDF="$STATE/cpuhog.pid"
mkdir -p "$STATE"
rm -f "/root/$OUT"

# Kill ANY stray cpuhog first so re-seeding can never accumulate busy loops
# (each leftover hog pegs a CPU core). Then start exactly one.
pkill -9 -f 'cpuhog -c' 2>/dev/null
rm -f "$PIDF"

bash -c 'exec -a cpuhog sh -c "while :; do :; done"' &
newpid=$!
echo "$newpid" > "$PIDF"
echo "cpu-hog-find: started cpuhog (pid $newpid)"
exit 0
