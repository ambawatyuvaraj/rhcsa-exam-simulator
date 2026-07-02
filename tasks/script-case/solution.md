# Reference solution — case statement

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
case "$1" in
  start)  echo starting ;;
  stop)   echo stopping ;;
  status) echo status ;;
esac
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
/usr/local/bin/<SCRIPT> start    # -> starting
/usr/local/bin/<SCRIPT> stop     # -> stopping
/usr/local/bin/<SCRIPT> status   # -> status
```
