#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "static hostname is $HN" 6 '[ "$(hostnamectl --static 2>/dev/null)" = "'"$HN"'" ]'
