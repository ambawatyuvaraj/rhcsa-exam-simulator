#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"

# Convert the SIZE param (e.g. 50M) to bytes, then allow 1.5x headroom since
# vacuum-size only drops whole archived journal files.
ckpt_expr "journal disk usage is at or below ${SIZE} (1.5x tolerance)" 6 '
  size="'"$SIZE"'"
  num=${size%[MmGgKk]}
  unit=${size#$num}
  case "$unit" in
    G|g) bytes=$((num*1024*1024*1024)) ;;
    M|m) bytes=$((num*1024*1024)) ;;
    K|k) bytes=$((num*1024)) ;;
    *)   bytes=$num ;;
  esac
  limit=$((bytes*3/2))
  # journalctl --disk-usage prints e.g. "... take up 2.9G in the file system."
  # The size token may be like 512K, 8.0M, 2.9G (optionally followed by B/iB).
  used=$(journalctl --disk-usage 2>/dev/null | grep -oE "[0-9]+(\.[0-9]+)?[KMGTkmgt]([iI]?[Bb])?" | head -1)
  [ -n "$used" ] || exit 1
  uval=$(printf "%s" "$used" | grep -oE "[0-9]+(\.[0-9]+)?")
  uunit=$(printf "%s" "$used" | grep -oE "[KMGTkmgt]" | head -1 | tr a-z A-Z)
  ubytes=$(awk -v v="$uval" -v u="$uunit" "BEGIN{m=1; if(u==\"K\")m=1024; else if(u==\"M\")m=1024*1024; else if(u==\"G\")m=1024*1024*1024; else if(u==\"T\")m=1024*1024*1024*1024; printf \"%d\", v*m}")
  [ "$ubytes" -le "$limit" ]
'
