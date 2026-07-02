# Reference solution — deny a user access to cron

```bash
# Add the username on its own line in /etc/cron.deny
echo <U> >> /etc/cron.deny
```
Verify: `grep -x <U> /etc/cron.deny`
