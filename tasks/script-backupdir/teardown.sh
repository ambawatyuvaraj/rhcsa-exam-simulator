#!/usr/bin/env bash
rm -f "/usr/local/bin/$SCRIPT" >/dev/null 2>&1 || true
rm -f "/root/backup-$SRCNAME.tar.gz" >/dev/null 2>&1 || true
rm -rf "/opt/$SRCNAME" >/dev/null 2>&1 || true
exit 0
