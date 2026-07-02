#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/etc/cron.d/$F exists"                          3 'test -f "/etc/cron.d/'"$F"'"'
ckpt_expr "runs every 10 min as root in /etc/cron.d/$F"    7 'grep -vE "^[[:space:]]*#" "/etc/cron.d/'"$F"'" | grep -qE "^\*/10[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+root[[:space:]]+.*logger[[:space:]]+sysjob"'
