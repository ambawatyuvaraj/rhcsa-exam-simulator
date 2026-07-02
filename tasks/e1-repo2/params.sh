#!/usr/bin/env bash
# Repository definitions for /etc/yum.repos.d/app.repo.
#
# The published RHCSA answer key uses an HTTP classroom mirror:
#   http://classroom.example.com/content/rhel8.0/x86_64/dvd/BaseOS
#   http://classroom.example.com/content/rhel8.0/x86_64/dvd/AppStream
# That host does not resolve in this OFFLINE environment, so we point the
# baseurls at the local on-disk package trees this repo provisions instead
# (same trees used by tasks/repo-config). The .repo file name and section
# names stay faithful to the key.
echo "REPO_FILE=/etc/yum.repos.d/app.repo"
echo "BASEOS_URL=file:///opt/rhcsa-repo/BaseOS"
echo "APPSTREAM_URL=file:///opt/rhcsa-repo/AppStream"
