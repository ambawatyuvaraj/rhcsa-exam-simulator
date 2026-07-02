#!/usr/bin/env bash
id simone >/dev/null 2>&1 || useradd simone
for p in /opt/jdata/report.txt /var/tmp/jnotes.log /srv/simone.cfg; do
  mkdir -p "$(dirname "$p")"; echo "owned by simone" >"$p"; chown simone "$p"
done
rm -rf /root/found
echo "find-files: seeded simone-owned files"
exit 0
