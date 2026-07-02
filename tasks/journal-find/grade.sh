#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUTF exists and is non-empty" 4 '[ -s /root/'"$OUTF"' ]'
ckpt_expr "/root/$OUTF contains chronyd entries" 4 \
  'grep -qi chronyd /root/'"$OUTF"' || grep -qi chrony /root/'"$OUTF"''
