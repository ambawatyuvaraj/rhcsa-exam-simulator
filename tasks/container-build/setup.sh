#!/usr/bin/env bash
command -v podman >/dev/null 2>&1 || dnf -y install podman >/dev/null 2>&1 || true   # self-heal: ensure container engine (real exam has it preinstalled)
podman image exists localhost/rhcsa-app:latest || \
  podman load -i "$RHCSA_ASSETS/rhcsa-app.tar" >/dev/null 2>&1
mkdir -p "$BD"
printf 'FROM localhost/rhcsa-app:latest\nLABEL rhcsa=build\nRUN echo built > /built.txt\n' > "$BD"/Containerfile
podman rmi -f "$IMG" >/dev/null 2>&1 || true
echo "container-build: Containerfile seeded in $BD"
exit 0
