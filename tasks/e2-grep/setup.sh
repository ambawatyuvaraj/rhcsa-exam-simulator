#!/usr/bin/env bash
dnf -y install iso-codes >/dev/null 2>&1 || true
rm -f /root/list
echo "e2-grep: ready (grep 'ng' from iso_639_3.xml)"
exit 0
