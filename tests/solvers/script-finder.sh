#!/usr/bin/env bash
  cat >/usr/local/bin/mysearch <<'EOF'
#!/bin/bash
find /usr -size +5k -size -50k -perm -4000 > /root/setuid.list
EOF
  chmod +x /usr/local/bin/mysearch; /usr/local/bin/mysearch
