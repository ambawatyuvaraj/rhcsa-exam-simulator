#!/usr/bin/env bash
# Remove the repo FILE too, not just the tree — a .repo pointing at a deleted
# file:// path makes EVERY later `dnf` command fail.
grep -rlF 'file:///opt/rhcsa-repo' /etc/yum.repos.d/ 2>/dev/null | xargs -r rm -f
rm -rf /opt/rhcsa-repo 2>/dev/null
dnf clean all >/dev/null 2>&1
exit 0
