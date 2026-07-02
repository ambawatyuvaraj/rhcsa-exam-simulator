#!/usr/bin/env bash
# Capture the image ID of localhost/rhcsa-app:latest into /root/$OUTF
podman image inspect --format '{{.Id}}' localhost/rhcsa-app:latest > "/root/$OUTF" 2>/dev/null
