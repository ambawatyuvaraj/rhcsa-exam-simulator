#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "container $CN exists" 2 'podman container exists '"$CN"''
ckpt_expr "$CN bind-mounts $BDIR at /hostdata read-only" 6 'podman inspect '"$CN"' --format "{{range .HostConfig.Binds}}{{println .}}{{end}}" 2>/dev/null | grep -E "^'"$BDIR"':/hostdata" | grep -q "ro"'
