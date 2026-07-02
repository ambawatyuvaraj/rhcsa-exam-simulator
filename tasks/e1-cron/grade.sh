#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "harry cron runs at 12:30 daily" 5 'crontab -l -u harry 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "^[[:space:]]*30[[:space:]]+12[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*"'
ckpt_expr "cron command is echo hello"     3 'crontab -l -u harry 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "echo[[:space:]]+\"?hello\"?"'
