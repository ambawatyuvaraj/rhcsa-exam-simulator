#!/usr/bin/env bash
dnf -y install rsync openssh-clients >/dev/null 2>&1 || true
mkdir -p /opt/datasrc
echo payload >/opt/datasrc/file1
echo "rsync-peer: /opt/datasrc/file1 seeded"
exit 0
