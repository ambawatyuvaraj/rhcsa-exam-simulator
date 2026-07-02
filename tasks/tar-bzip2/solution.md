# Reference solution — create a bzip2-compressed tar archive

```bash
tar cjf /root/<ARC>.tar.bz2 /opt/bz
tar tjf /root/<ARC>.tar.bz2     # verify contents
```

`j` selects bzip2 compression, `c` creates, `f` names the output file.
