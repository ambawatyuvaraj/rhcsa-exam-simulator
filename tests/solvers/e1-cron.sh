#!/usr/bin/env bash
# Solver for e1-cron: install harry's crontab with the daily 12:30 echo job,
# preserving any existing lines and staying idempotent (don't duplicate the job).
id harry >/dev/null 2>&1 || useradd harry
line='30 12 * * * /bin/echo hello'
{
  crontab -l -u harry 2>/dev/null | grep -vE '^[[:space:]]*30[[:space:]]+12[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+/bin/echo[[:space:]]+hello[[:space:]]*$'
  echo "$line"
} | crontab -u harry -
