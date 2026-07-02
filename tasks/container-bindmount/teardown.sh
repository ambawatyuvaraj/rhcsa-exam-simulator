#!/usr/bin/env bash
podman rm -f "$CN" >/dev/null 2>&1
rm -rf "$BDIR" >/dev/null 2>&1
exit 0
