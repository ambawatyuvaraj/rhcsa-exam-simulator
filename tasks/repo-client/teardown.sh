#!/usr/bin/env bash
rm -f /etc/yum.repos.d/peerrepo.repo 2>/dev/null
dnf clean all >/dev/null 2>&1
exit 0
