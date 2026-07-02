# Reference solution — gzip-compressed tar archive

`tar` flags: `c` create, `z` gzip compression, `f` output file.

```bash
tar czf /root/test.tar.gz /var/tmp    # create a gzip-compressed tar of /var/tmp
ls -l /root/test.tar.gz
tar tzf /root/test.tar.gz | head      # list members to verify
```
