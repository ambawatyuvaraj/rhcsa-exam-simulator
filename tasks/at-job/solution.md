# Reference solution — one-time at job

`at` schedules a command to run ONCE at a future time (unlike cron, which repeats).
Pipe the command(s) into `at <timespec>`; `atq` lists pending jobs and `at -c <n>`
shows job <n>'s contents.

```bash
dnf install -y at                             # the 'at' command + scheduler
systemctl enable --now atd
# schedule the job (any future time works):
at now + 1 hour <<'ATEOF'
/bin/touch /root/<F>
ATEOF

atq                                      # list queued jobs (note the job number)
at -c "$(atq | awk 'NR==1{print $1}')"   # show that job's command body
```
