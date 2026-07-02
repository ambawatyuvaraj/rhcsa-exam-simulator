#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true   # self-heal: ensure container engine (real exam has it preinstalled)
podman image exists localhost/rhcsa-app:latest || \
  podman load -i "$RHCSA_ASSETS/rhcsa-app.tar" >/dev/null 2>&1
podman rm -f "$CN" >/dev/null 2>&1 || true
rm -f "/root/$OUT" >/dev/null 2>&1 || true
podman run -d --name "$CN" localhost/rhcsa-app:latest \
  sh -c 'echo RHCSA-LOG-MARKER; sleep infinity' >/dev/null 2>&1
echo "container-logs: image seeded, container $CN emitting log marker, /root/$OUT cleared"
exit 0
