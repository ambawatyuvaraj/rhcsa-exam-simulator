#!/usr/bin/env bash
chattr -i "/root/$F" 2>/dev/null || true
echo "protected content" > "/root/$F"
echo "file-immutable: seeded /root/$F"
exit 0
