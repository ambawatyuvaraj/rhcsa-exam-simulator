#!/usr/bin/env bash
cp -p /etc/locale.conf /etc/locale.conf.rhcsabak 2>/dev/null || true   # -p: keep 644 in the backup
echo "localectl-locale: ready (target LANG=$LC)"
exit 0
