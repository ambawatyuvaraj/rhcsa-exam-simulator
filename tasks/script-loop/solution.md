# Reference solution — shell script with a loop

Create the script (replace `<SCRIPT>`, `<DIR>` and `<N>` with the values shown
in your task):

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
mkdir -p <DIR>
for i in $(seq 1 <N>); do
  touch "<DIR>/file$i"
done
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Run and verify:

```bash
/usr/local/bin/<SCRIPT>
ls <DIR>
```
