# Reference solution — gzip-compressed tar archive

`tar` flags: `c` create, `z` gzip compression, `f` output file.

```bash
tar czf /root/archive.gz /usr/local    # create a gzip-compressed tar of /usr/local
ls -l /root/archive.gz
tar tzf /root/archive.gz | head        # list members to verify
```
