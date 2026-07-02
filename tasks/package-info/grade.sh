#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "/root/$OUT contains $PKG version" 8 'test -f "/root/'"$OUT"'" && [ "$(tr -d "[:space:]" < "/root/'"$OUT"'")" = "$(rpm -q --qf "%{VERSION}" "'"$PKG"'")" ]'
