#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "container $CN exists" 2 'podman container exists '"$CN"''
ckpt_expr "container $CN is running" 4 'podman ps --format "{{.Names}}" 2>/dev/null | grep -qx '"$CN"''
