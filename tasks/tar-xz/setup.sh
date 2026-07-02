#!/usr/bin/env bash
mkdir -p /opt/xz/docs
printf 'alpha\n'  >/opt/xz/one.txt
printf 'beta\n'   >/opt/xz/two.txt
printf 'gamma\n'  >/opt/xz/docs/three.txt
rm -f "/root/$ARC.tar.xz"
echo "tar-xz: seeded /opt/xz -> /root/$ARC.tar.xz"
exit 0
