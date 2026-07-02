#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "operator cron runs every 3 minutes"     8 'crontab -l -u operator 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "^\*/3[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*"'
ckpt_expr "cron command is logger EX200 Testing"   4 'crontab -l -u operator 2>/dev/null | grep -F "logger" | grep -q "EX200 Testing"'
