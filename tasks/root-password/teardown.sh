#!/usr/bin/env bash
# Restore the documented default so the practice VM returns to its known state.
echo "root:password" | chpasswd 2>/dev/null
exit 0
