# Reference solution — read stdin, uppercase

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
read -r line
echo "${line^^}"
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
echo hello | /usr/local/bin/<SCRIPT>   # -> HELLO
```
