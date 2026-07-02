#!/usr/bin/env bash
groupadd -f "$G"
mkdir -p "/$DIR"
echo "acl-default: directory /$DIR and group $G ready"
exit 0
