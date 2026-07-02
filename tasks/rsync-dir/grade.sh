#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$DEST/rsrc exists" 3 '[ -d '"$DEST"'/rsrc ]'
ckpt_expr "$DEST/rsrc matches /opt/rsrc" 5 'diff -r /opt/rsrc '"$DEST"'/rsrc >/dev/null 2>&1'
