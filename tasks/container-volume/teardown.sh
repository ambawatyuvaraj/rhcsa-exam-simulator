#!/usr/bin/env bash
podman rm -f "$CN" >/dev/null 2>&1
podman volume rm "$VOL" >/dev/null 2>&1
exit 0
