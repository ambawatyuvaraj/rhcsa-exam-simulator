#!/usr/bin/env bash
sed -i "/^$U$/d" /etc/cron.deny 2>/dev/null
[ -f /etc/cron.allow.rhcsabak ] && mv -f /etc/cron.allow.rhcsabak /etc/cron.allow 2>/dev/null
userdel -rf "$U" >/dev/null 2>&1
exit 0
