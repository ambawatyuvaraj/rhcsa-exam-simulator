#!/usr/bin/env bash
# Ensure the baseline PASS_MAX_DAYS is the stock default (99999) so the task is
# NOT already satisfied. Only ever touch the PASS_MAX_DAYS line — never UMASK or
# any other directive in /etc/login.defs.
if grep -qE '^[[:space:]]*PASS_MAX_DAYS' /etc/login.defs 2>/dev/null; then
  sed -i -E 's/^[[:space:]]*PASS_MAX_DAYS.*/PASS_MAX_DAYS\t99999/' /etc/login.defs
else
  printf 'PASS_MAX_DAYS\t99999\n' >> /etc/login.defs
fi
echo "password-aging: baseline PASS_MAX_DAYS=99999"
exit 0
