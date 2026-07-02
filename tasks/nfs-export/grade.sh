#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "user remoteu exists"                       2 user_exists remoteu
ckpt "user remoteu has UID 4400"                 3 user_uid remoteu 4400
ckpt_expr "remoteu home is /exports/nodeshare/remoteu" 2 \
  '[ "$(getent passwd remoteu | cut -d: -f6)" = /exports/nodeshare/remoteu ]'
ckpt_expr "nfs-server is active"                 3 'systemctl is-active nfs-server >/dev/null 2>&1'
ckpt_expr "/exports/nodeshare is exported"       4 'exportfs -v 2>/dev/null | grep -q /exports/nodeshare'
