#!/usr/bin/env bash
id sarah >/dev/null 2>&1 || useradd sarah
mkdir -p /root/find.user
find / -user sarah -type f -exec cp -a {} /root/find.user/ \; 2>/dev/null
exit 0    # find returns non-zero on unreadable dirs; the copies still happened
