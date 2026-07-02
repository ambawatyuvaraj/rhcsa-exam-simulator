#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/findfiles is a directory"              2 is_dir /root/findfiles
ckpt_expr "all jacques-owned files were copied"    8 'for f in report.txt jnotes.log jacques.cfg; do [ -e "/root/findfiles/$f" ] || exit 1; done; exit 0'
ckpt_expr "at least the 3 seeded files are present" 2 '[ "$(find /root/findfiles -type f 2>/dev/null | wc -l)" -ge 3 ]'
