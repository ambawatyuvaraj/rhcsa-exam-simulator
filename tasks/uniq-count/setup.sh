#!/usr/bin/env bash
cat >/opt/dups.txt <<'EOF'
apple
banana
apple
cherry
banana
apple
date
cherry
banana
elderberry
EOF
rm -f "/root/$OUT"
echo "uniq-count: seeded /opt/dups.txt -> /root/$OUT"
exit 0
