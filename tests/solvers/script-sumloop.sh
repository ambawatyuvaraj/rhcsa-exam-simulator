#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
total=0
for ((i=1; i<=$1; i++)); do
  total=$((total + i))
done
echo "$total"
EOF
chmod +x "/usr/local/bin/$SCRIPT"
