# Reference solution — daily cron job at a fixed time

The five cron fields are minute, hour, day-of-month, month, day-of-week. To run once a
day at a fixed time, set the minute and hour and leave the other three as `*`.

```bash
# Exam method: `crontab -e -u <U>` and type the line. Equivalent non-interactively:
crontab -u <U> - <<'EOF'
<M> <H> * * * /usr/bin/logger daily-<U>
EOF
crontab -l -u <U>             # verify
```
