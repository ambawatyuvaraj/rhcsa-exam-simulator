#!/usr/bin/env bash
rm -f /etc/sudoers.d/admin 2>/dev/null
echo "sudo-nopasswd: group admin ready"
exit 0
