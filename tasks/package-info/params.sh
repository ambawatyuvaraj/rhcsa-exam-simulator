#!/usr/bin/env bash
. "$RHCSA_LIB/params.sh"
echo "PKG=$(rand_choice bash coreutils systemd)"
echo "OUT=$(rand_choice pkgver.txt version.txt info.txt)"
