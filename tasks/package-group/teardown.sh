#!/usr/bin/env bash
# Guard: never uninstall podman (see setup.sh) — it would break container tasks.
case "$MEMBER" in podman) MEMBER=buildah ;; esac
dnf -y remove "$MEMBER" >/dev/null 2>&1 || true
exit 0
