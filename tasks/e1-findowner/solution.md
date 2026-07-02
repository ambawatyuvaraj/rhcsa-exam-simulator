# Reference solution — find files by owner and copy them

`find / -user sarah` walks the whole filesystem for files owned by sarah, and
`-exec cp -a {} DIR \;` copies each match into the destination (which must exist).

```bash
mkdir -p /root/find.user                                                  # destination directory
find / -user sarah -type f -exec cp -a {} /root/find.user/ \; 2>/dev/null  # copy every file owned by sarah
ls /root/find.user                                                        # verify the copies
```
