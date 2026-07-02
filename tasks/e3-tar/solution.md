# Reference solution — gzip and bzip2 tar archives

`tar` flags: `c` create, `f` output file, `z` gzip, `j` bzip2.

```bash
tar czf /root/test.tar.gz /var/tmp    # gzip-compressed archive
tar cjf /root/test.tar.bz /var/tmp    # bzip2-compressed archive
ls -l /root/test.tar.gz /root/test.tar.bz
tar tzf /root/test.tar.gz | head      # verify gzip archive
tar tjf /root/test.tar.bz | head      # verify bzip2 archive
```
