#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "/root/$OUT is a directory" 2 is_dir "/root/$OUT"
ckpt_expr "all files modified within $DAYS days were copied" 5 \
  'while IFS= read -r f; do [ -n "$f" ] || continue; [ -e "/root/'"$OUT"'/$(basename "$f")" ] || exit 1; done < <(find /opt/mtsrc -type f -mtime -'"$DAYS"'); exit 0'
ckpt_expr "no old files were copied" 3 \
  '[ "$(find "/root/'"$OUT"'" -type f 2>/dev/null | wc -l)" -eq "$(find /opt/mtsrc -type f -mtime -'"$DAYS"' | wc -l)" ]'
