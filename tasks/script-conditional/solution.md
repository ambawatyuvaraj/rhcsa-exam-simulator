# Reference solution — conditional shell script

Create the script (replace `<SCRIPT>` and `<THR>` with the values shown in your
task):

```bash
cat > /usr/local/bin/<SCRIPT> <<'EOF'
#!/usr/bin/env bash
if [ "$1" -gt <THR> ]; then
  echo big
else
  echo small
fi
EOF
chmod +x /usr/local/bin/<SCRIPT>
```

Verify:

```bash
/usr/local/bin/<SCRIPT> $((<THR>+10))   # -> big
/usr/local/bin/<SCRIPT> $((<THR>-10))   # -> small
```
