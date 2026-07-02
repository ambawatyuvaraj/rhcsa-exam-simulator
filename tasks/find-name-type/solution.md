# Reference solution — find regular files by name glob

```bash
find /opt/ntsrc -type f -name '*.<EXT>' > /root/<OUT>
```

`-type f` restricts the match to regular files, so a directory named
`something.<EXT>` is excluded. Quote the glob so the shell does not expand it.
