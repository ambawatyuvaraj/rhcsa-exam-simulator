#!/usr/bin/env bash
# Print big if $1 > $THR, else small.
cat >"/usr/local/bin/$SCRIPT" <<EOF
#!/usr/bin/env bash
if [ "\$1" -gt $THR ]; then
  echo big
else
  echo small
fi
EOF
chmod +x "/usr/local/bin/$SCRIPT"
