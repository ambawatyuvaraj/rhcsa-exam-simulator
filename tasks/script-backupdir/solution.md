# Reference solution — back up a directory to a tar.gz

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
dir="$1"
base=$(basename "$dir")
tar czf "/root/backup-$base.tar.gz" -C "$(dirname "$dir")" "$base"
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify (with the seeded source directory shown in your task, e.g. `/opt/<SRCNAME>`):

```bash
/usr/local/bin/<SCRIPT> /opt/<SRCNAME>
file /root/backup-<SRCNAME>.tar.gz          # -> gzip compressed data
tar tzf /root/backup-<SRCNAME>.tar.gz       # lists the directory contents
```
