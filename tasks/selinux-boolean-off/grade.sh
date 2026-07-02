#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Persistence = the DEFAULT column (after the comma) must be 'off', not just runtime.
ckpt_expr "boolean '$SB' is off and persistent" 8 \
  "getsebool $SB 2>/dev/null | grep -qw off && semanage boolean -l 2>/dev/null | grep -E \"^$SB[[:space:]]\" | grep -qE ',[[:space:]]*off'"
