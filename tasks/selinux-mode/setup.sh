#!/usr/bin/env bash
setenforce 0 >/dev/null 2>&1
sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config 2>/dev/null
echo "selinux-mode: seeded permissive"
exit 0
