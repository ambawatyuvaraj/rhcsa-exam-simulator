#!/usr/bin/env bash
cat >/opt/text.txt <<'EOF'
The quick brown fox.
Mixed CASE with Numbers 123 and symbols !@#.
already UPPER stays upper.
EOF
rm -f "/root/$OUT"
echo "tr-transform: seeded /opt/text.txt -> /root/$OUT"
exit 0
