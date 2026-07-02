#!/usr/bin/env bash
setsebool -P "$SB" on >/dev/null 2>&1 || true
echo "selinux-boolean-off: seeded '$SB' to on"
exit 0
