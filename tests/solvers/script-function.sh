#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
greet() {
  echo "Hello, $1!"
}
greet "$1"
EOF
chmod +x "/usr/local/bin/$SCRIPT"
