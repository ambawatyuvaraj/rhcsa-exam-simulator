# Reference solution — extract a gzip tar archive

```bash
mkdir -p <DEST>
tar xzf /root/<ARC>.tar.gz -C <DEST>
ls <DEST>
```

`x` extracts, `z` handles gzip, `f` names the archive file, and `-C` selects the
target directory.
