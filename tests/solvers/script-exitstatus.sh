#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
if test -e "$1"; then
  echo exists
else
  echo missing
fi
EOF
chmod +x "/usr/local/bin/$SCRIPT"
