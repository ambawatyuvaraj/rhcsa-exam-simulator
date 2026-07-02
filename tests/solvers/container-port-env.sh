#!/usr/bin/env bash
# Run detached container $CN with env $EV=$VAL and published host port $HP
podman rm -f "$CN" >/dev/null 2>&1
podman run -d --name "$CN" -e "$EV=$VAL" -p "$HP:80" localhost/rhcsa-app:latest >/dev/null 2>&1
