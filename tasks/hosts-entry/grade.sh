#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "{{HN}} resolves to {{IP}}" 6 'getent hosts '"$HN"' 2>/dev/null | grep -q "^'"$IP"'\b" || grep -E "^'"$IP"'\s+.*\b'"$HN"'\b" /etc/hosts'
