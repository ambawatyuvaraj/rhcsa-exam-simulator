#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "persistent fcontext equivalence $DST = $SRC" 8 \
  "semanage fcontext -l 2>/dev/null | grep -Eq '^$DST[[:space:]]+=[[:space:]]+$SRC\$' || semanage fcontext -l 2>/dev/null | grep -q '$DST = $SRC'"
