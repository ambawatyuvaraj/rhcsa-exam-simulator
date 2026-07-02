#!/usr/bin/env bash
mkdir -p /opt/sizesrc/sub
# Sizes chosen to straddle the 10k..100k window (find -size uses 1024-byte k).
dd if=/dev/zero of=/opt/sizesrc/small.bin   bs=1024 count=5    >/dev/null 2>&1   # 5k  (excluded)
dd if=/dev/zero of=/opt/sizesrc/mid1.bin    bs=1024 count=40   >/dev/null 2>&1   # 40k (included)
dd if=/dev/zero of=/opt/sizesrc/sub/mid2.bin bs=1024 count=80  >/dev/null 2>&1   # 80k (included)
dd if=/dev/zero of=/opt/sizesrc/big.bin     bs=1024 count=200  >/dev/null 2>&1   # 200k (excluded)
rm -f "/root/$OUT"
echo "find-size: seeded /opt/sizesrc -> /root/$OUT"
exit 0
