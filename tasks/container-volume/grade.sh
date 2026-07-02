#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt_expr "volume $VOL exists" 3 'podman volume exists '"$VOL"''
ckpt_expr "container $CN mounts volume $VOL" 5 'podman inspect '"$CN"' --format "{{range .Mounts}}{{.Name}} {{end}}" 2>/dev/null | grep -qw '"$VOL"''
