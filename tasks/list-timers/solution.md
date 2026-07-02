# Reference solution — list systemd timers

systemd timers are the modern replacement for cron jobs. `list-timers --all` shows
every timer (including inactive ones) with its next/last run; save that list.

```bash
systemctl list-timers --all --no-legend > /root/<OUT>
cat /root/<OUT>
```
