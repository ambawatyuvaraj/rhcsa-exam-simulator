#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
if id "$1" >/dev/null 2>&1; then
  echo present
else
  echo absent
fi
EOF
chmod +x "/usr/local/bin/$SCRIPT"
