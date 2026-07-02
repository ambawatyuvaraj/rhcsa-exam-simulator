#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "harry cron runs every 3 minutes" 5 'crontab -l -u harry 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "^[[:space:]]*\*/3[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*"'
ckpt_expr "cron command is logger EX200 Testing" 3 'crontab -l -u harry 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "logger[[:space:]]+\"?EX200[[:space:]]+Testing\"?"'
