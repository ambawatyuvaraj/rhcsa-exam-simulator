#!/usr/bin/env bash
crontab -r -u "$U" >/dev/null 2>&1
userdel -rf "$U" >/dev/null 2>&1
exit 0
