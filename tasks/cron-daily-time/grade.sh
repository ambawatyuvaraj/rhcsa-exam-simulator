#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user '$U' exists"                               2 user_exists "$U"
ckpt "cron for '$U' runs daily at $H:$M"              5 crontab_has "$U" "^$M $H \* \* \*"
ckpt_expr "cron command is logger daily-$U"           3 'crontab -l -u "$U" 2>/dev/null | grep -F "logger" | grep -q "daily-'"$U"'"'
