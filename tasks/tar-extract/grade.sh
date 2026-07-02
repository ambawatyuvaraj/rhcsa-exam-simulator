#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "$DEST exists" 2 is_dir "$DEST"
ckpt_expr "all archived files extracted" 6 'for f in file1 file2 file3; do [ -e "$DEST/$f" ] || exit 1; done'
