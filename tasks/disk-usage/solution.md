# Reference solution — disk usage of /var

```bash
du -sh /var > /root/<OUT>
cat /root/<OUT>      # e.g. "1.2G    /var"
```
`-s` summarises (one total line); `-h` makes it human-readable.
