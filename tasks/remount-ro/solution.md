# Reference solution — remount read-only

```bash
mount -o remount,ro /mnt/<MP>
findmnt /mnt/<MP>      # options include ro
```
`remount` changes mount options on an already-mounted filesystem without
detaching it.
