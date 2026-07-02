#!/usr/bin/env bash
podman rm -f "$CN" >/dev/null 2>&1
rm -f "/root/$OUT" >/dev/null 2>&1
exit 0
