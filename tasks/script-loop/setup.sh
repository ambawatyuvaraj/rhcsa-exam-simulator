#!/usr/bin/env bash
rm -f "/usr/local/bin/$SCRIPT" >/dev/null 2>&1 || true
rm -rf "$DIR" >/dev/null 2>&1 || true
echo "script-loop: removed prior /usr/local/bin/$SCRIPT and $DIR"
exit 0
