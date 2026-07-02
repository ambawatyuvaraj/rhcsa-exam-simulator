#!/usr/bin/env bash
cat > "/usr/local/bin/$SCRIPT" <<'EOF'
#!/usr/bin/env bash
case "$1" in
  start)  echo starting ;;
  stop)   echo stopping ;;
  status) echo status ;;
esac
EOF
chmod +x "/usr/local/bin/$SCRIPT"
