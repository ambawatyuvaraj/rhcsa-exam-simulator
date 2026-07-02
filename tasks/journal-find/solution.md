# Reference solution — save a service's journal to a file

`journalctl -u <unit>` shows one unit's log; `-b` limits it to the current boot.
Redirect that to the file.

```bash
journalctl -u chronyd -b > /root/<OUTF>
test -s /root/<OUTF> && grep -i chronyd /root/<OUTF>   # verify it has content
```
