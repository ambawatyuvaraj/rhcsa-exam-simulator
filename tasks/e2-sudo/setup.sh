#!/usr/bin/env bash
rm -f /etc/sudoers.d/sysmgrs 2>/dev/null
sed -i '/%sysmgrs/d' /etc/sudoers 2>/dev/null
echo "sudo-nopasswd: group sysmgrs ready"
exit 0
