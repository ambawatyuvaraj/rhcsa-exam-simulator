# Reference solution — daily cron job for user harry

`30 12 * * *` means minute 30 of hour 12 (12:30 PM), every day, every month,
every weekday.

```bash
crontab -e -u harry
   # add this line:
   # 30 12 * * * /bin/echo hello
crontab -l -u harry          # verify the entry
```

Equivalently, non-interactively:

```bash
echo '30 12 * * * /bin/echo hello' | crontab -u harry -
```
