#!/usr/bin/env bash
mkdir -p /opt/bz/docs
printf 'alpha\n'  >/opt/bz/one.txt
printf 'beta\n'   >/opt/bz/two.txt
printf 'gamma\n'  >/opt/bz/docs/three.txt
rm -f "/root/$ARC.tar.bz2"
echo "tar-bzip2: seeded /opt/bz -> /root/$ARC.tar.bz2"
exit 0
