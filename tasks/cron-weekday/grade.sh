#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user '$U' exists"                                  2 user_exists "$U"
ckpt "cron for '$U' runs 02:00 Mon,Wed,Fri"              5 crontab_has "$U" "^0 2 \* \* (1,3,5|[Mm]on,[Ww]ed,[Ff]ri)"
ckpt_expr "cron command is echo wk"                      3 'crontab -l -u "$U" 2>/dev/null | grep -F "echo" | grep -qw "wk"'
