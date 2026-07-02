#!/usr/bin/env bash
mkdir -p /opt/rhcsa-repo/BaseOS /opt/rhcsa-repo/AppStream
command -v createrepo_c >/dev/null 2>&1 || dnf -y install createrepo_c >/dev/null 2>&1 || true
createrepo_c /opt/rhcsa-repo/BaseOS    >/dev/null 2>&1 || true
createrepo_c /opt/rhcsa-repo/AppStream >/dev/null 2>&1 || true
echo "repo-config: local repo trees created under /opt/rhcsa-repo"
exit 0
