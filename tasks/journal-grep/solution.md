# Reference solution — save matching journal lines

Read the current boot's journal (`-b`) and keep only the lines matching the target
string, writing them to the file.

```bash
journalctl -b | grep <STR> > /root/<OUT>
test -s /root/<OUT>        # verify the file is non-empty
```
