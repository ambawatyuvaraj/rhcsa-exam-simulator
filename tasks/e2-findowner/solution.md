# Reference solution — find files by owner and copy them

`find / -user jacques` walks the whole filesystem for files owned by jacques, and
`-exec cp -a {} DIR \;` copies each match into the destination (which must exist).

```bash
mkdir -p /root/findfiles                                                  # destination directory
find / -user jacques -type f -exec cp -a {} /root/findfiles/ \; 2>/dev/null  # copy every file owned by jacques
ls /root/findfiles                                                        # verify the copies
```
