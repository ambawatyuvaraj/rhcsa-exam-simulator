#!/usr/bin/env bash
mkdir -p "/root/$OUT"
find /opt/permsrc -type f -perm "$MODE" -exec cp -t "/root/$OUT" {} +
