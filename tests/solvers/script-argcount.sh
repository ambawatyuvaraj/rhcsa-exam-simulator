#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
if [ "$#" -ne 2 ]; then
  echo "usage: $(basename "$0") ARG1 ARG2" >&2
  exit 1
fi
echo ok
EOF
chmod +x "/usr/local/bin/$SCRIPT"
