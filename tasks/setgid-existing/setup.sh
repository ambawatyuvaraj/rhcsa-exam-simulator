#!/usr/bin/env bash
groupadd -f "$G"
mkdir -p "/$DIR"
chmod 0770 "/$DIR"
echo "setgid-existing: directory /$DIR and group $G ready"
exit 0
