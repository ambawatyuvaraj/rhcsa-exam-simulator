# Reference solution — save high-priority journal entries

journald ranks messages by priority. `-p err` selects priority *err and worse*
(err, crit, alert, emerg); `-b` limits to the current boot. Save those to the file.

```bash
journalctl -b -p err > /root/<OUT>
test -s /root/<OUT>        # verify
```
