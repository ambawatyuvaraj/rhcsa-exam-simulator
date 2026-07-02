#!/usr/bin/env bash
id frank >/dev/null 2>&1 || useradd frank
id grace >/dev/null 2>&1 || useradd grace
rm -f /var/tmp/fstab 2>/dev/null
echo "acl-permissions: users frank and grace ready"
exit 0
