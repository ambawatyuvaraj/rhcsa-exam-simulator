# Reference solution — recurring cron job

cron runs a command on a repeating schedule. The five time fields are: minute, hour,
day-of-month, month, day-of-week. `*/3` in the minute field means "every 3 minutes".

```bash
# Exam method: `crontab -e -u operator` and type the line. Equivalent non-interactively:
crontab -u operator - <<'EOF'
*/3 * * * * /usr/bin/logger "EX200 Testing"
EOF
crontab -l -u operator        # verify the entry is installed
```
