# Reference solution — cron job every three minutes for user harry

`*/3 * * * *` means "every 3rd minute", every hour, every day, every month,
every weekday.

```bash
crontab -e -u harry
   # add this line:
   # */3 * * * * logger "EX200 Testing"
crontab -l -u harry          # verify the entry
```

Equivalently, non-interactively:

```bash
echo '*/3 * * * * logger "EX200 Testing"' | crontab -u harry -
```
