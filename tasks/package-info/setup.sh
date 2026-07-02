#!/usr/bin/env bash
rpm -q "$PKG" >/dev/null 2>&1 || dnf -y install "$PKG" >/dev/null 2>&1 || true
rm -f "/root/$OUT" 2>/dev/null
echo "package-info: '$PKG' installed, /root/$OUT cleared"
exit 0
