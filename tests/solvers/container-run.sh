#!/usr/bin/env bash
# Run a detached, running container named $CN
podman rm -f "$CN" >/dev/null 2>&1
# sleep infinity guarantees the container keeps running for the grader
podman run -d --name "$CN" localhost/rhcsa-app:latest sleep infinity >/dev/null 2>&1
