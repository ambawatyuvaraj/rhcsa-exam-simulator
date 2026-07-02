#!/usr/bin/env bash
dnf -y remove "$PKG" >/dev/null 2>&1 || true
echo "package-version: ensured '$PKG' is not installed yet"
exit 0
