#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "running it creates the N files" 10 'rm -rf '"$DIR"'; /usr/local/bin/'"$SCRIPT"' >/dev/null 2>&1; ok=1; for i in $(seq 1 '"$N"'); do [ -e '"$DIR"'/file$i ] || ok=0; done; [ $ok = 1 ]'
