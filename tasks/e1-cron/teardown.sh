#!/usr/bin/env bash
# Undo: clear harry's crontab. Idempotent (account left intact).
id harry >/dev/null 2>&1 && crontab -r -u harry >/dev/null 2>&1
exit 0
