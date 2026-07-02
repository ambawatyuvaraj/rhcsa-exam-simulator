#!/usr/bin/env bash
cat > /usr/local/bin/newsearch <<'EOF'
#!/bin/bash
find /usr -size +30k -size -50k -perm /u+s > /root/scriptfind
EOF
chmod +x /usr/local/bin/newsearch
/usr/local/bin/newsearch
exit 0
