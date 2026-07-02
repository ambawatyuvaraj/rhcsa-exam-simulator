#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
dir="$1"
base=$(basename "$dir")
tar czf "/root/backup-$base.tar.gz" -C "$(dirname "$dir")" "$base"
EOF
chmod +x "/usr/local/bin/$SCRIPT"
