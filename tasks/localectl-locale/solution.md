# Reference solution — set the system locale

`localectl set-locale` sets the system-wide language/locale persistently (writes
/etc/locale.conf), affecting messages, sorting, and formats for new sessions.

```bash
localectl set-locale LANG=<LC>
localectl status
cat /etc/locale.conf    # verify -> LANG=<LC>
```
