#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/$OUT is a directory" 2 is_dir "/root/$OUT"
ckpt_expr "all files with mode $MODE were copied (by name)" 6 \
  'while IFS= read -r f; do [ -n "$f" ] || continue; [ -e "/root/'"$OUT"'/$(basename "$f")" ] || exit 1; done < <(find /opt/permsrc -type f -perm '"$MODE"'); exit 0'
ckpt_expr "no extra files were copied" 2 \
  '[ "$(find "/root/'"$OUT"'" -type f 2>/dev/null | wc -l)" -eq "$(find /opt/permsrc -type f -perm '"$MODE"' | wc -l)" ]'
