#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "interface rhcsafw is in zone $ZONE (active)" 3 \
  'firewall-cmd --get-zone-of-interface=rhcsafw 2>/dev/null | grep -qx "'"$ZONE"'"'
ckpt_expr "rhcsafw zone $ZONE is persistent (permanent config)" 2 \
  'firewall-cmd --permanent --zone="'"$ZONE"'" --query-interface=rhcsafw 2>/dev/null | grep -qx yes'
