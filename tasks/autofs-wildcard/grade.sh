#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "autofs is enabled and active" 3 svc_ok autofs
ckpt_expr "/autohomes/u1 automounts via wildcard" 7 \
  'ls /autohomes/u1/README >/dev/null 2>&1 && findmnt /autohomes/u1 >/dev/null 2>&1'
