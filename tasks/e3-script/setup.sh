#!/usr/bin/env bash
rm -f /usr/local/bin/myfind
rm -rf /root/myfiles
# Guarantee at least one file in the 400k-800k window exists under /usr/share so
# a correct script produces non-empty output (some systems have few such files).
mkdir -p /usr/share/rhcsa-sample
dd if=/dev/zero of=/usr/share/rhcsa-sample/half-meg.bin bs=1k count=600 status=none 2>/dev/null
echo "e3-script: ready"
exit 0
