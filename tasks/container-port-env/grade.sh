#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "$CN has env $EV=$VAL" 4 'podman inspect '"$CN"' --format "{{range .Config.Env}}{{println .}}{{end}}" 2>/dev/null | grep -qx "'"$EV"'='"$VAL"'"'
ckpt_expr "$CN publishes host port $HP" 4 'podman inspect '"$CN"' --format "{{.HostConfig.PortBindings}}" 2>/dev/null | grep -q "'"$HP"'"'
