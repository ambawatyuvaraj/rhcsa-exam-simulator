#!/usr/bin/env bash
mkdir -p "$SRC" "$DST"
semanage fcontext -d "$DST" 2>/dev/null
restorecon -R "$DST" 2>/dev/null
echo "selinux-fcontext-equal: seeded $SRC and $DST"
exit 0
