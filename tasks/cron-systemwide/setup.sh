#!/usr/bin/env bash
rm -f "/etc/cron.d/$F" 2>/dev/null
echo "cron-systemwide: /etc/cron.d/$F cleared"
exit 0
