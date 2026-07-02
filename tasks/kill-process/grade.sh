#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Pass when no 'sleep' process tagged with $MARK remains. Filtering by
# comm=sleep means the grader's own shell (comm=bash, whose command line also
# contains $MARK) is never counted, and PID reuse can't cause a false match.
ckpt_expr "the $MARK process was terminated" 8 \
  'n=0; for pid in $(pgrep -f "'"$MARK"'" 2>/dev/null); do [ "$(ps -o comm= -p "$pid" 2>/dev/null)" = sleep ] && n=$((n+1)); done; [ "$n" -eq 0 ]'
