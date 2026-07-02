#!/usr/bin/env bash
id jacques >/dev/null 2>&1 || useradd jacques
for p in /opt/jdata/report.txt /var/tmp/jnotes.log /srv/jacques.cfg; do
  mkdir -p "$(dirname "$p")"; echo "owned by jacques" >"$p"; chown jacques "$p"
done
rm -rf /root/findfiles
echo "find-files: seeded jacques-owned files"
exit 0
