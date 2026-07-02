#!/usr/bin/env bash
rm -f "/usr/local/bin/$SCRIPT" >/dev/null 2>&1 || true
rm -f "/root/backup-$SRCNAME.tar.gz" >/dev/null 2>&1 || true
rm -rf "/opt/$SRCNAME" >/dev/null 2>&1 || true
mkdir -p "/opt/$SRCNAME"
echo "sample-content-$SRCNAME" > "/opt/$SRCNAME/data.txt"
echo "more lines" >> "/opt/$SRCNAME/data.txt"
echo "script-backupdir: seeded /opt/$SRCNAME and removed any prior artifacts"
exit 0
