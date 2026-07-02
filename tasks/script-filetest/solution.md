# Reference solution — path type test

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
if [ -d "$1" ]; then
  echo dir
elif [ -f "$1" ]; then
  echo file
else
  echo other
fi
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
/usr/local/bin/<SCRIPT> /etc            # -> dir
/usr/local/bin/<SCRIPT> /etc/hostname   # -> file
```
