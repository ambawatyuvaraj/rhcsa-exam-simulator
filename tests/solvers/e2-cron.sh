#!/usr/bin/env bash
# Solver for e2-cron: install harry's crontab with the every-3-minutes logger job,
# preserving any existing lines and staying idempotent (don't duplicate the job).
id harry >/dev/null 2>&1 || useradd harry
line='*/3 * * * * logger "EX200 Testing"'
{
  crontab -l -u harry 2>/dev/null | grep -vE '^[[:space:]]*\*/3[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+logger[[:space:]]+"?EX200[[:space:]]+Testing"?[[:space:]]*$'
  echo "$line"
} | crontab -u harry -
