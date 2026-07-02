#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true   # self-heal: ensure container engine (real exam has it preinstalled)
podman image exists localhost/rhcsa-app:latest || \
  podman load -i "$RHCSA_ASSETS/rhcsa-app.tar" >/dev/null 2>&1
podman rm -f "$CN" >/dev/null 2>&1 || true
mkdir -p "$BDIR"
echo "RHCSA bind-mount source" > "$BDIR/marker.txt"
echo "container-bindmount: image seeded, $BDIR populated, container $CN cleared"
exit 0
