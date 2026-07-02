#!/usr/bin/env bash
dnf -y remove "$PKG" >/dev/null 2>&1 || true
exit 0
