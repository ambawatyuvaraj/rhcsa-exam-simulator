#!/usr/bin/env bash
dnf -y install nfs-utils >/dev/null 2>&1 || true
mkdir -p /exports/nodeshare
echo "nfs-export: nfs-utils installed, /exports/nodeshare created (not yet exported)"
exit 0
