#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
if [ -d "$1" ]; then
  echo dir
elif [ -f "$1" ]; then
  echo file
else
  echo other
fi
EOF
chmod +x "/usr/local/bin/$SCRIPT"
