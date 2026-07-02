#!/usr/bin/env bash
id natasha >/dev/null 2>&1 || useradd natasha
( crontab -l -u natasha 2>/dev/null; echo "23 14 * * * /usr/bin/echo hiya" ) | crontab -u natasha -
