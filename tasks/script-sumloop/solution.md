# Reference solution — sum 1..N with a loop

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
total=0
for ((i=1; i<=$1; i++)); do
  total=$((total + i))
done
echo "$total"
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
/usr/local/bin/<SCRIPT> 10   # -> 55
/usr/local/bin/<SCRIPT> 5    # -> 15
```
