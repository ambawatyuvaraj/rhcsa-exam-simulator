# Reference solution — find recently modified files and copy them

```bash
mkdir -p /root/<OUT>
find /opt/mtsrc -type f -mtime -<DAYS> -exec cp -t /root/<OUT> {} +
```

`-mtime -<DAYS>` matches files modified less than `<DAYS>` * 24 hours ago
(i.e. within the last `<DAYS>` days).
