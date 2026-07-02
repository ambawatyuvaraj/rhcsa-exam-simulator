#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 || useradd "$U"
semanage login -d "$U" 2>/dev/null
echo "selinux-user-map: seeded $U"
exit 0
