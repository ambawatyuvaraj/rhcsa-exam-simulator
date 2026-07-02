#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "User '$U' exists"               3 user_exists "$U"
ckpt_expr "account $U is locked"      5 'passwd -S "$U" 2>/dev/null | awk "{print \$2}" | grep -q "^L"'
