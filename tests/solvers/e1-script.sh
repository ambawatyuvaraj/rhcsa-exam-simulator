#!/usr/bin/env bash
mkdir -p /root/myfiles
cat > /usr/local/bin/mysearch <<'EOF'
#!/bin/sh
find /usr/share/ -type f -size -1M -exec cp -prvf {} /root/myfiles/ \;
EOF
chmod a+x /usr/local/bin/mysearch
/usr/local/bin/mysearch
