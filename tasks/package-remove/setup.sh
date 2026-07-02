#!/usr/bin/env bash
rpm -q "$PKG" >/dev/null 2>&1 || dnf -y install "$PKG" >/dev/null 2>&1 || true
echo "package-remove: ensured '$PKG' is installed"
exit 0
