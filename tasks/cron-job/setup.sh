#!/usr/bin/env bash
id operator >/dev/null 2>&1 || useradd operator
crontab -r -u operator >/dev/null 2>&1 || true
echo "cron-job: user 'operator' ready"
exit 0
