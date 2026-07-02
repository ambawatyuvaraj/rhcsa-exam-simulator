#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "natasha cron runs at 14:23"  8 'crontab -l -u natasha 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "^[[:space:]]*23[[:space:]]+14[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*"'
ckpt_expr "cron command is echo hiya"   4 'crontab -l -u natasha 2>/dev/null | grep -vE "^[[:space:]]*#" | grep -qE "echo[[:space:]]+hiya"'
