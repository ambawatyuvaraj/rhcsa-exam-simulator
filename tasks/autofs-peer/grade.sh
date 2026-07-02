#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "autofs is enabled and active"              4 svc_ok autofs
ckpt_expr "user remoteu exists with UID 4400"    3 'id -u remoteu >/dev/null 2>&1 && [ "$(id -u remoteu)" = 4400 ]'
ckpt_expr "/rhome/remoteu automounts from the peer export" 7 \
  'ls /rhome/remoteu >/dev/null 2>&1 && findmnt /rhome/remoteu >/dev/null 2>&1'
