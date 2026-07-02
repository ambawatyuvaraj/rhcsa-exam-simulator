#!/usr/bin/env bash
rm -f /var/tmp/fstab 2>/dev/null
userdel -rf frank >/dev/null 2>&1
userdel -rf grace >/dev/null 2>&1
exit 0
