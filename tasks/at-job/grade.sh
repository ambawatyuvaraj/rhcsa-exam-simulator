#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "an at job is queued" 4 'atq 2>/dev/null | grep -q .'
ckpt_expr "the queued job runs touch /root/$F" 4 'for j in $(atq 2>/dev/null | awk "{print \$1}"); do at -c $j 2>/dev/null | grep -q "/root/'"$F"'" && exit 0; done; exit 1'
