#!/usr/bin/env bash
# Script echoes "$WORD $1 $2".
cat >"/usr/local/bin/$SCRIPT" <<EOF
#!/usr/bin/env bash
echo "$WORD \$1 \$2"
EOF
chmod +x "/usr/local/bin/$SCRIPT"
