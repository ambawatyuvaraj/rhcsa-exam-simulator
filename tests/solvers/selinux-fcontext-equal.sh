#!/usr/bin/env bash
semanage fcontext -a -e "$SRC" "$DST"
restorecon -R "$DST" 2>/dev/null
