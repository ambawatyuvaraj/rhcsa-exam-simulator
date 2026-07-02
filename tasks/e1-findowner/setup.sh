#!/usr/bin/env bash
id sarah >/dev/null 2>&1 || useradd sarah
for p in /opt/sdata/report.txt /var/tmp/snotes.log /srv/sarah.cfg; do
  mkdir -p "$(dirname "$p")"; echo "owned by sarah" >"$p"; chown sarah "$p"
done
rm -rf /root/find.user
echo "find-files: seeded sarah-owned files"
exit 0
