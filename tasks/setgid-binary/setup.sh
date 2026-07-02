#!/usr/bin/env bash
mkdir -p /usr/local/bin
cp -f /bin/sleep "/usr/local/bin/$B"
chmod 0755 "/usr/local/bin/$B"
echo "setgid-binary: seeded /usr/local/bin/$B"
exit 0
