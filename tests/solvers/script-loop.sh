#!/usr/bin/env bash
# Create $DIR and touch file1..fileN.
cat >"/usr/local/bin/$SCRIPT" <<EOF
#!/usr/bin/env bash
mkdir -p "$DIR"
for i in \$(seq 1 $N); do
  touch "$DIR/file\$i"
done
EOF
chmod +x "/usr/local/bin/$SCRIPT"
