#!/usr/bin/env bash
dnf -y install kbd >/dev/null 2>&1 || true
# Record current keymap for teardown; start from a different default than target.
localectl status 2>/dev/null | awk -F: '/VC Keymap/{gsub(/ /,"",$2);print $2}' \
  > /var/lib/rhcsa-sim/localectl-keymap.bak 2>/dev/null || true
echo "localectl-keymap: ready (target $KM)"
exit 0
