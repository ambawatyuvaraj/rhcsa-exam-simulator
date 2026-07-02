# Reference solution — bzip2-compressed tar archive

`tar` flags: `c` create, `v` verbose, `j` bzip2 compression, `f` output file.

```bash
tar -cvjf /root/data.tar.bz2 /usr/local    # create a bzip2-compressed tar of /usr/local
ls -l /root/data.tar.bz2
tar tjf /root/data.tar.bz2 | head          # list members to verify
```
