#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "package '$PKG' is NOT installed" 8 '! rpm -q "'"$PKG"'" >/dev/null 2>&1'
