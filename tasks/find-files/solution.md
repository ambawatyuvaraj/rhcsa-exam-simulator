# Reference solution — find files by owner and copy them

`find / -user jacques` walks the whole filesystem for files owned by jacques;
`-exec cp -a ... \;` copies each match (preserving attributes) into the target
directory, which you create first.

```bash
mkdir -p /root/findfiles                                  # create the destination
find / -user jacques -exec cp -a {} /root/findfiles/ \;   # copy every file owned by jacques
ls -l /root/findfiles                                     # verify the copies
```
