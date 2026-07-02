#!/usr/bin/env bash
# Build image $IMG from Containerfile in $BD (root podman)
podman build -t "$IMG" "$BD" >/dev/null 2>&1
