#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 || useradd "$U"
rm -f /root/.ssh/id_rhcsa /root/.ssh/id_rhcsa.pub 2>/dev/null
echo "ssh-keyauth: seeded $U"
exit 0
