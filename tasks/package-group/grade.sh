#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
# A package group is "installed" iff its member software is present. Verify a
# representative member package of the group is installed (lenient, reboot-safe).
ckpt "representative package '$MEMBER' of group '$GROUPNAME' is installed" 8 pkg_installed "$MEMBER"
