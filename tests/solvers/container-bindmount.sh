#!/usr/bin/env bash
podman run -d --name "$CN" -v "$BDIR":/hostdata:ro,Z localhost/rhcsa-app:latest >/dev/null 2>&1
