# Reference solution — find files by owner and copy them

`find / -user simone` walks the whole filesystem for files owned by simone, and
`-exec cp {} DIR \;` copies each match into the destination (which must exist).

```bash
mkdir -p /root/found                                 # destination directory
find / -user simone -exec cp {} /root/found \;       # copy every file owned by simone
ls /root/found                                       # verify the copies
```
