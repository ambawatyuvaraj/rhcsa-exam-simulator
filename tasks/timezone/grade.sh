#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "timezone is $TZ" 6 '[ "$(timedatectl show -p Timezone --value 2>/dev/null)" = "'"$TZ"'" ]'
