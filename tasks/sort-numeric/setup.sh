#!/usr/bin/env bash
# Values where lexical and numeric order differ (e.g. 9 vs 100).
cat >/opt/nums.txt <<'EOF'
100
9
42
7
1000
23
5
88
3
250
EOF
rm -f "/root/$OUT"
echo "sort-numeric: seeded /opt/nums.txt -> /root/$OUT"
exit 0
