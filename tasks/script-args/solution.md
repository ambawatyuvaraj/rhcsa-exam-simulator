# Reference solution — positional arguments

Create the script (replace `<SCRIPT>` and `<WORD>` with the values shown in your
task):

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
echo "<WORD> $1 $2"
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
/usr/local/bin/<SCRIPT> alpha beta   # -> <WORD> alpha beta
```
