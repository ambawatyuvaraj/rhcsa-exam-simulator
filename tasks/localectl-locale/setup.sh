#!/usr/bin/env bash
restorecon -F /etc/locale.conf 2>/dev/null   # heal a label broken by an older teardown
cp -p /etc/locale.conf /etc/locale.conf.rhcsabak 2>/dev/null || true   # -p: keep 644 in the backup
echo "localectl-locale: ready (target LANG=$LC)"
exit 0
