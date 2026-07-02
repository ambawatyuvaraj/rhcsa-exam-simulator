#!/usr/bin/env bash
# Troubleshooting fault: wipe operator's crontab (the account stays).
crontab -r -u operator >/dev/null 2>&1
echo "SYMPTOM: the scheduled cron job for user 'operator' has disappeared"
