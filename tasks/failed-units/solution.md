# Reference solution — list failed units

systemd records every unit that failed to start. `systemctl --failed` lists them —
the first thing to check when "something isn't running" — and you save that list.

```bash
# Units currently in the failed state:
systemctl --failed --no-legend > /root/<OUT>
cat /root/<OUT>
```
