#!/usr/bin/env bash
dnf -y install autofs nfs-utils >/dev/null 2>&1 || true
id remoteu >/dev/null 2>&1 || useradd -u 4400 -M -d /rhome/remoteu remoteu 2>/dev/null
echo "autofs-peer: autofs + nfs-utils installed; remoteu seeded (no home created)"
exit 0
