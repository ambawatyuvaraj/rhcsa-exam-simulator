#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
count=0
while IFS= read -r line; do
  count=$((count + 1))
done < "$1"
echo "$count"
EOF
chmod +x "/usr/local/bin/$SCRIPT"
