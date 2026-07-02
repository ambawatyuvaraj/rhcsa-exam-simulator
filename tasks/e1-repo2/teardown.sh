#!/usr/bin/env bash
# Undo: remove app.repo (and any other .repo pointing at the local tree — a
# .repo referencing a deleted file:// path makes every later dnf call fail) and
# the local repo trees. Idempotent.
rm -f /etc/yum.repos.d/app.repo
grep -rlF 'file:///opt/rhcsa-repo' /etc/yum.repos.d/ 2>/dev/null | xargs -r rm -f
rm -rf /opt/rhcsa-repo 2>/dev/null
dnf clean all >/dev/null 2>&1
exit 0
