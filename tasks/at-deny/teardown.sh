#!/usr/bin/env bash
sed -i "/^$U$/d" /etc/at.deny 2>/dev/null
[ -f /etc/at.allow.rhcsabak ] && mv -f /etc/at.allow.rhcsabak /etc/at.allow 2>/dev/null
userdel -rf "$U" >/dev/null 2>&1
exit 0
