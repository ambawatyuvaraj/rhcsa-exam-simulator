# Reference solution — scheduled cron job for a user

`23 14 * * *` means minute 23 of hour 14 (14:23), every day.

```bash
crontab -e -u natasha
   # add this line:
   # 23 14 * * * /usr/bin/echo hiya
crontab -l -u natasha          # verify the entry
```
(natasha is the user created in the users/group task.)
