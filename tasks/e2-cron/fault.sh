#!/usr/bin/env bash
# Troubleshooting fault: wipe harry's crontab (the account stays).
id harry >/dev/null 2>&1 && crontab -r -u harry >/dev/null 2>&1
echo "SYMPTOM: the scheduled cron job for user 'harry' has disappeared"
