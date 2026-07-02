#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "running it produces /root/backup-'"$SRCNAME"'.tar.gz" 5 '
  rm -f /root/backup-'"$SRCNAME"'.tar.gz
  /usr/local/bin/'"$SCRIPT"' /opt/'"$SRCNAME"' >/dev/null 2>&1
  [ -f /root/backup-'"$SRCNAME"'.tar.gz ]'
ckpt_expr "archive is gzip-compressed" 2 'file /root/backup-'"$SRCNAME"'.tar.gz 2>/dev/null | grep -qi gzip'
ckpt_expr "archive contains the seeded content" 3 'tar tzf /root/backup-'"$SRCNAME"'.tar.gz 2>/dev/null | grep -q data.txt'
