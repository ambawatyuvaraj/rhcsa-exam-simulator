#!/usr/bin/env bash
semanage fcontext -d "$DST" 2>/dev/null
rm -rf "$SRC" "$DST"
exit 0
