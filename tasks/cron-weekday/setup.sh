#!/usr/bin/env bash
id "$U" >/dev/null 2>&1 || useradd "$U"
crontab -r -u "$U" >/dev/null 2>&1 || true
echo "cron-weekday: user '$U' ready"
exit 0
