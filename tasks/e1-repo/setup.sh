#!/usr/bin/env bash
# Starting state: the local package trees exist (so a correct app.repo will
# actually work offline), but there is NO working app.repo yet, so the baseline
# scores ~0. Idempotent.

# 1) Provision the local DVD-equivalent package trees under /opt/rhcsa-repo.
mkdir -p /opt/rhcsa-repo/BaseOS /opt/rhcsa-repo/AppStream
command -v createrepo_c >/dev/null 2>&1 || dnf -y install createrepo_c >/dev/null 2>&1 || true
[ -d /opt/rhcsa-repo/BaseOS/repodata ]    || createrepo_c /opt/rhcsa-repo/BaseOS    >/dev/null 2>&1 || true
[ -d /opt/rhcsa-repo/AppStream/repodata ] || createrepo_c /opt/rhcsa-repo/AppStream >/dev/null 2>&1 || true

# 2) Remove the target repo file and any other .repo that already points at the
#    local tree (a stale file:// repo would make every later dnf call fail).
rm -f /etc/yum.repos.d/app.repo
grep -rlF 'file:///opt/rhcsa-repo' /etc/yum.repos.d/ 2>/dev/null | xargs -r rm -f
dnf clean all >/dev/null 2>&1

echo "e1-repo: local repo trees ready under /opt/rhcsa-repo; app.repo removed"
exit 0
