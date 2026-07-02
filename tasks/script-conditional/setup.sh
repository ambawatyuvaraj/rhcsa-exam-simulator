#!/usr/bin/env bash
rm -f "/usr/local/bin/$SCRIPT" >/dev/null 2>&1 || true
echo "script-conditional: removed any prior /usr/local/bin/$SCRIPT"
exit 0
