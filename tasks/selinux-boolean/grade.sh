#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# Persistence = the DEFAULT column (after the comma) must be 'on', not just runtime.
# A plain `setsebool foo on` (no -P) leaves "(on , off)" and must NOT pass.
ckpt_expr "boolean '$SBOOL' is on and persistent" 8 \
  "getsebool $SBOOL 2>/dev/null | grep -qw on && semanage boolean -l 2>/dev/null | grep -E \"^$SBOOL[[:space:]]\" | grep -qE ',[[:space:]]*on'"
