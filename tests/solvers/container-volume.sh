#!/usr/bin/env bash
podman volume create "$VOL" >/dev/null 2>&1
podman run -d --name "$CN" -v "$VOL":/data localhost/rhcsa-app:latest >/dev/null 2>&1
