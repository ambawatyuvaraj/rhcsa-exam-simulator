# Reference solution — vacuum the journal by size

`--vacuum-size` deletes the oldest *archived* journal files until on-disk usage drops
below the given size — a way to cap how much space logs consume.

```bash
journalctl --vacuum-size=<SIZE>
journalctl --disk-usage    # verify usage is now under <SIZE>
```
