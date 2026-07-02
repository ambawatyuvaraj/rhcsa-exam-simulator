#!/usr/bin/env bash
chattr -i "/root/$F" 2>/dev/null || true
rm -f "/root/$F"
exit 0
