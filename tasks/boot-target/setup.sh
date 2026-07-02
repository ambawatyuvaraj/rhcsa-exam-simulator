#!/usr/bin/env bash
# Make the task meaningful: set a non-multi-user default if possible.
if systemctl list-unit-files graphical.target >/dev/null 2>&1; then
  systemctl set-default graphical.target >/dev/null 2>&1 || true
fi
echo "boot-target: default target seeded to graphical (change it to multi-user)"
exit 0
