#!/usr/bin/env bash
# Load image archive at /root/$TARNAME.tar (yields localhost/rhcsa-app:latest)
podman image exists localhost/rhcsa-app:latest || \
  podman load -i "/root/$TARNAME.tar" >/dev/null 2>&1
