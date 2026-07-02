#!/usr/bin/env bash
prev="$(cat /var/lib/rhcsa-sim/grub-default-kernel.bak 2>/dev/null)"
[ -n "$prev" ] && grubby --set-default "$prev" >/dev/null 2>&1
rm -f /var/lib/rhcsa-sim/grub-default-kernel.bak /var/lib/rhcsa-sim/grub-target-kernel 2>/dev/null
exit 0
