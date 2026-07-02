#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/etc/skel/$F exists"     8 '[ -f "/etc/skel/$F" ]'
