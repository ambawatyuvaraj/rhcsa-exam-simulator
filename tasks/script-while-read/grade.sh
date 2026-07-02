#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "script exists and is executable" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ]'
ckpt_expr "counts lines correctly (K='"$K"')" 6 '
  d=$(mktemp -d); f="$d/lines.txt"
  i=0; while [ "$i" -lt '"$K"' ]; do echo "line $i" >>"$f"; i=$((i+1)); done
  out=$(/usr/local/bin/'"$SCRIPT"' "$f" 2>/dev/null); rm -rf "$d"
  [ "$out" = '"$K"' ]'
  ckpt_expr "does not invoke wc" 2 '[ -x /usr/local/bin/'"$SCRIPT"' ] && ! grep -qw wc /usr/local/bin/'"$SCRIPT"
