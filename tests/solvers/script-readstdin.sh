#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
read -r line
echo "${line^^}"
EOF
chmod +x "/usr/local/bin/$SCRIPT"
