#!/usr/bin/env bash
. "$RHCSA_LIB/grade-lib.sh"
ckpt "package '$PKG' is installed" 8 pkg_installed "$PKG"
