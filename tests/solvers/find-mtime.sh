#!/usr/bin/env bash
mkdir -p "/root/$OUT"
find /opt/mtsrc -type f -mtime -"$DAYS" -exec cp -t "/root/$OUT" {} +
