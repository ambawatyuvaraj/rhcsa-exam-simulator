#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Find the candidate's tagged 'sleep' process (filter by comm=sleep so the
# grader's own pgrep/bash — whose command line also contains $MARK — is not
# mistaken for the target) and check its nice value.
ckpt_expr "a $MARK process runs with nice $NICE" 8 \
  'for pid in $(pgrep -f "'"$MARK"'" 2>/dev/null); do [ "$(ps -o comm= -p "$pid" 2>/dev/null)" = sleep ] && [ "$(ps -o ni= -p "$pid" 2>/dev/null | tr -d " ")" = "'"$NICE"'" ] && exit 0; done; exit 1'
