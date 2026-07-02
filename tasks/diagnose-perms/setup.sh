#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 || useradd "$U" 2>/dev/null
mkdir -p "/$DIR"
echo data >"/$DIR/file"
chown root:root "/$DIR" "/$DIR/file"
chmod 700 "/$DIR"
chmod 600 "/$DIR/file"
echo "diagnose-perms: user $U cannot yet read /$DIR/file"
exit 0
