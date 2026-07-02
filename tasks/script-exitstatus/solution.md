# Reference solution — branch on exit status

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
if test -e "$1"; then
  echo exists
else
  echo missing
fi
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
/usr/local/bin/<SCRIPT> /etc     # -> exists
/usr/local/bin/<SCRIPT> /nope    # -> missing
```
