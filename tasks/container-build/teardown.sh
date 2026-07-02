#!/usr/bin/env bash
podman rmi -f "$IMG" >/dev/null 2>&1
rm -rf "$BD" 2>/dev/null
exit 0
