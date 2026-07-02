#!/usr/bin/env bash
pkill -f "$MARK" 2>/dev/null
echo "process-nice: cleaned any prior '$MARK' process (start it yourself)"
exit 0
