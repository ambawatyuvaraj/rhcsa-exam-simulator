#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "port {{FWPORT}}/tcp allowed (runtime)" 4 firewall_port "$FWPORT/tcp"
ckpt_expr "permanent port rule" 4 'firewall-cmd --permanent --list-ports 2>/dev/null | tr " " "\n" | grep -qx '"$FWPORT"'/tcp'
