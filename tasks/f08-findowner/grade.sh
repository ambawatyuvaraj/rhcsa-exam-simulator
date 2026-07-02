#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/found is a directory"              2 is_dir /root/found
ckpt_expr "all simone-owned files were copied"    8 'for f in report.txt jnotes.log simone.cfg; do [ -e "/root/found/$f" ] || exit 1; done; exit 0'
ckpt_expr "at least the 3 seeded files are present" 2 '[ "$(find /root/found -type f 2>/dev/null | wc -l)" -ge 3 ]'
