#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
PIDF="/var/lib/rhcsa-sim/renice.pid"
ckpt_expr "the running $MARK process has nice value $NICE" 8 \
  'pid=$(cat '"$PIDF"' 2>/dev/null); [ -n "$pid" ] && [ "$(ps -o comm= -p "$pid" 2>/dev/null)" = sleep ] && [ "$(ps -o ni= -p "$pid" 2>/dev/null | tr -d " ")" = "'"$NICE"'" ]'
