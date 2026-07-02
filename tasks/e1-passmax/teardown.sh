#!/usr/bin/env bash
# Restore the stock default. Only ever touch the PASS_MAX_DAYS line.
if grep -qE '^[[:space:]]*PASS_MAX_DAYS' /etc/login.defs 2>/dev/null; then
  sed -i -E 's/^[[:space:]]*PASS_MAX_DAYS.*/PASS_MAX_DAYS\t99999/' /etc/login.defs
else
  printf 'PASS_MAX_DAYS\t99999\n' >> /etc/login.defs
fi
exit 0
