#!/usr/bin/env bash
timedatectl set-timezone UTC >/dev/null 2>&1
echo "timezone: seeded UTC"
exit 0
