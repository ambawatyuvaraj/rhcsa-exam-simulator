#!/usr/bin/env bash
# Set PASS_MAX_DAYS to 20 in /etc/login.defs (only that line).
if grep -qE '^[[:space:]]*PASS_MAX_DAYS' /etc/login.defs 2>/dev/null; then
  sed -i -E 's/^[[:space:]]*PASS_MAX_DAYS.*/PASS_MAX_DAYS\t20/' /etc/login.defs
else
  printf 'PASS_MAX_DAYS\t20\n' >> /etc/login.defs
fi
