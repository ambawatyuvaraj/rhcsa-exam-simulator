# Reference solution — gzip-compressed tar archive

`tar -czf` Creates a gZipped archive into a File: `c`=create, `z`=gzip, `f`=file.

```bash
tar -czf /root/backup.tar.gz /etc     # create a gzip tar of /etc
file /root/backup.tar.gz              # verify: "gzip compressed data"
tar tzf /root/backup.tar.gz | head    # list contents to confirm
```
