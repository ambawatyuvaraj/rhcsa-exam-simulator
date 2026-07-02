# Reference solution — count lines with while-read

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
count=0
while IFS= read -r line; do
  count=$((count + 1))
done < "$1"
echo "$count"
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
printf 'a\nb\nc\n' > /tmp/t.txt
/usr/local/bin/<SCRIPT> /tmp/t.txt   # -> 3
```
