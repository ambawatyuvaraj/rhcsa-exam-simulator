# Reference solution — cron job on specific weekdays

The 5th cron field is day-of-week (0/7=Sun, 1=Mon … 6=Sat); a comma list runs the job
on several days — here Monday, Wednesday, Friday.

```bash
# Exam method: `crontab -e -u <U>` and type the line. Equivalent non-interactively:
crontab -u <U> - <<'EOF'
0 2 * * 1,3,5 /usr/bin/echo wk
EOF
crontab -l -u <U>             # verify
```
