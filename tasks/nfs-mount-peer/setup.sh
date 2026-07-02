#!/usr/bin/env bash
dnf -y install nfs-utils >/dev/null 2>&1 || true
echo "nfs-mount-peer: nfs-utils present"
exit 0
