#!/usr/bin/env bash
# Cron job parameters (FIXED) — user harry runs `logger "EX200 Testing"` every 3 minutes.
echo "U=harry"
echo "SCHED=*/3 * * * *"
echo 'CMD=logger "EX200 Testing"'
