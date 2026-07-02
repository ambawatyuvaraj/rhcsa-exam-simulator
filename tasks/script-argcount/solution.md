# Reference solution — argument-count validation

Replace `<SCRIPT>` with the value shown in your task.

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
if [ "$#" -ne 2 ]; then
  echo "usage: $(basename "$0") ARG1 ARG2" >&2
  exit 1
fi
echo ok
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
/usr/local/bin/<SCRIPT> one        # prints usage to stderr, exit 1
/usr/local/bin/<SCRIPT> one two    # -> ok, exit 0
```
