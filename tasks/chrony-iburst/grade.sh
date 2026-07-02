#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "chrony.conf has server $SRV"                      4 chrony_server "$SRV"
ckpt_expr "server $SRV line uses iburst"                3 'grep -vE "^[[:space:]]*#" /etc/chrony.conf | grep -E "^(server|pool)[[:space:]]+'"$SRV"'\b" | grep -qw iburst'
ckpt "chronyd is enabled and active"                    3 svc_ok chronyd
