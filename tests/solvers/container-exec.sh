#!/usr/bin/env bash
# Ensure the target container is actually running before exec (it may have been
# left stopped). start is idempotent on an already-running container.
podman start "$CN" >/dev/null 2>&1
podman exec "$CN" cat /etc/os-release > "/root/$OUT" 2>/dev/null
