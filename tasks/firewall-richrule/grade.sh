#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "permanent rich rule accepting ssh from $FWSRC" 6 \
  'firewall-cmd --permanent --list-rich-rules 2>/dev/null | grep -q "'"$FWSRC"'" && firewall-cmd --permanent --list-rich-rules 2>/dev/null | grep -q "ssh"'
