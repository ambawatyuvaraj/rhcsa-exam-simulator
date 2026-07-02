#!/usr/bin/env bash
prev="$(cat /var/lib/rhcsa-sim/localectl-keymap.bak 2>/dev/null)"
[ -z "$prev" ] && prev="us"
localectl set-keymap "$prev" >/dev/null 2>&1 || localectl set-keymap us >/dev/null 2>&1
rm -f /var/lib/rhcsa-sim/localectl-keymap.bak 2>/dev/null
exit 0
