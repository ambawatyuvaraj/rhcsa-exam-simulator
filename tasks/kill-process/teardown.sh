#!/usr/bin/env bash
# Never pkill on an empty pattern (it would match every process).
[ -n "$MARK" ] && pkill -f "$MARK" 2>/dev/null
exit 0
