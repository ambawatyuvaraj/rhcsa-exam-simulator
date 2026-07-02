#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
echo $(( $1 + $2 ))
EOF
chmod +x "/usr/local/bin/$SCRIPT"
