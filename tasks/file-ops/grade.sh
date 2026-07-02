#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "$BASE/$SUB is a directory" 3 is_dir "$BASE/$SUB"
ckpt "$BASE/$SUB/keep.txt exists" 2 path_exists "$BASE/$SUB/keep.txt"
ckpt_expr "host.copy matches /etc/hostname" 3 'diff /etc/hostname "$BASE/host.copy" >/dev/null 2>&1'
