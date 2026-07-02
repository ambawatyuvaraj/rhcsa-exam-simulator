#!/usr/bin/env bash
id natasha >/dev/null 2>&1 && crontab -r -u natasha >/dev/null 2>&1
echo "f08-cron: ready (user natasha comes from the users/group task)"
exit 0
