#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/find.user is a directory"               2 is_dir /root/find.user
ckpt_expr "all sarah-owned files were copied"        8 'for f in report.txt snotes.log sarah.cfg; do [ -e "/root/find.user/$f" ] || exit 1; done; exit 0'
ckpt_expr "at least the 3 seeded files are present"  2 '[ "$(find /root/find.user -type f 2>/dev/null | wc -l)" -ge 3 ]'
